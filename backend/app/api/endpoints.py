from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app import crud, models
from app.schemas import (
    UserCreate, UserLogin, UserOut, Token,
    ConversationCreate, ConversationOut,
    MessageOut, ChatRequest, ChatResponse, UserUpdate, PasswordUpdate
)
from app.core.security import (
    get_password_hash, verify_password, create_access_token,
    create_refresh_token, get_current_user, get_user_from_refresh
)
from app.llm_model import generate_reply
from sqlalchemy.future import select

api_router = APIRouter()

# Auth endpoints
@api_router.post("/auth/register", response_model=UserOut, status_code=201)
async def register(user_in: UserCreate, db: AsyncSession = Depends(get_db)):
    existing = await crud.get_user_by_email(db, user_in.email)
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed = get_password_hash(user_in.password)
    user = await crud.create_user(db, user_in, hashed)
    return user

@api_router.get("/auth/me", response_model=UserOut)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user

@api_router.post("/auth/login", response_model=Token)
async def login(user_in: UserLogin, db: AsyncSession = Depends(get_db)):
    user = await crud.get_user_by_email(db, user_in.email)
    if not user or not verify_password(user_in.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    return Token(
        access_token=create_access_token(subject=str(user.id)),
        refresh_token=create_refresh_token(subject=str(user.id)),
    )

@api_router.post("/auth/refresh", response_model=Token)
async def refresh(token: str):
    user_id = get_user_from_refresh(token)
    return Token(
        access_token=create_access_token(subject=user_id),
        refresh_token=create_refresh_token(subject=user_id),
    )

# Conversations
@api_router.post("/chat", response_model=ConversationOut, status_code=201)
async def create_chat(conv_in: ConversationCreate, db: AsyncSession = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    conv = await crud.create_conversation(db, owner_id=current_user.id, title=conv_in.title or "New Chat")
    return conv

@api_router.get("/chat", response_model=list[ConversationOut])
async def list_chats(db: AsyncSession = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    return await crud.list_conversations(db, owner_id=current_user.id)

@api_router.delete("/chat/{conversation_id}", status_code=204)
async def delete_chat(conversation_id: int, db: AsyncSession = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    ok = await crud.delete_conversation(db, conversation_id, owner_id=current_user.id)
    if not ok:
        raise HTTPException(status_code=404, detail="Conversation not found")
    return

@api_router.get("/chat/{conversation_id}/messages", response_model=list[MessageOut])
async def get_messages(conversation_id: int, db: AsyncSession = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    conv = await crud.get_conversation(db, conversation_id, owner_id=current_user.id)
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")
    return await crud.list_messages(db, conversation_id, owner_id=current_user.id)

@api_router.post("/chat/{conversation_id}/message", response_model=ChatResponse, status_code=201)
async def send_message(conversation_id: int, req: ChatRequest, db: AsyncSession = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    conv = await crud.get_conversation(db, conversation_id, owner_id=current_user.id)
    if not conv:
        raise HTTPException(status_code=404, detail="Conversation not found")

    # Save user message
    user_msg = await crud.add_message(db, conversation_id, role="user", content=req.content)

    # Call your LLM
    reply_text, token_count = generate_reply(req.content, temperature=req.temperature, max_tokens=req.max_tokens)

    # Save assistant reply
    assistant_msg = await crud.add_message(db, conversation_id, role="assistant", content=reply_text, token_count=token_count)

    return {"message": assistant_msg}

@api_router.put("/auth/update", response_model=UserOut)
async def update_user(
    user_in: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    # Update fields
    if user_in.full_name is not None:
        current_user.full_name = user_in.full_name
    if user_in.email is not None:
        result = await db.execute(
            select(models.User).where(
                models.User.email == user_in.email,
                models.User.id != current_user.id
            )
        )
        existing = result.scalars().first()
        if existing:
            raise HTTPException(status_code=400, detail="Email already used by another user")
        current_user.email = user_in.email
    if user_in.phone is not None:
        current_user.phone = user_in.phone

    db.add(current_user)
    await db.commit()
    await db.refresh(current_user)
    return current_user

@api_router.put("/auth/update-password")
async def update_password(
    pw: PasswordUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    # Cek password lama
    if not verify_password(pw.old_password, current_user.hashed_password):
        raise HTTPException(status_code=400, detail="Password lama salah")

    # Update ke password baru
    current_user.hashed_password = get_password_hash(pw.new_password)
    db.add(current_user)
    await db.commit()
    return {"message": "Password berhasil diperbarui"}