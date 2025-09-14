from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from typing import Optional, List
from app import models
from app.schemas import UserCreate

# Users
async def get_user_by_email(db: AsyncSession, email: str) -> Optional[models.User]:
    res = await db.execute(select(models.User).where(models.User.email == email))
    return res.scalar_one_or_none()

async def create_user(db: AsyncSession, user_in: UserCreate, hashed_password: str) -> models.User:
    user = models.User(email=user_in.email, full_name=user_in.full_name, hashed_password=hashed_password)
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

# Conversations
async def create_conversation(db: AsyncSession, owner_id: int, title: str = "New Chat") -> models.Conversation:
    conv = models.Conversation(owner_id=owner_id, title=title)
    db.add(conv)
    await db.commit()
    await db.refresh(conv)
    return conv

async def list_conversations(db: AsyncSession, owner_id: int) -> List[models.Conversation]:
    res = await db.execute(
        select(models.Conversation)
        .options(selectinload(models.Conversation.messages))
        .where(models.Conversation.owner_id == owner_id)
        .order_by(models.Conversation.updated_at.desc())
    )
    return res.scalars().all()

async def get_conversation(db: AsyncSession, conv_id: int, owner_id: int) -> Optional[models.Conversation]:
    res = await db.execute(
        select(models.Conversation)
        .where(models.Conversation.id == conv_id, models.Conversation.owner_id == owner_id)
    )
    return res.scalar_one_or_none()

async def delete_conversation(db: AsyncSession, conv_id: int, owner_id: int) -> bool:
    res = await db.execute(
        select(models.Conversation)
        .where(models.Conversation.id == conv_id, models.Conversation.owner_id == owner_id)
    )
    conv = res.scalar_one_or_none()
    if not conv:
        return False
    await db.delete(conv)
    await db.commit()
    return True

# Messages
async def add_message(db: AsyncSession, conversation_id: int, role: str, content: str, token_count: int | None = None) -> models.Message:
    msg = models.Message(conversation_id=conversation_id, role=role, content=content, token_count=token_count)
    db.add(msg)
    await db.commit()
    await db.refresh(msg)
    return msg

async def list_messages(db: AsyncSession, conversation_id: int, owner_id: int) -> List[models.Message]:
    res = await db.execute(
        select(models.Message)
        .join(models.Conversation, models.Conversation.id == models.Message.conversation_id)
        .where(models.Message.conversation_id == conversation_id, models.Conversation.owner_id == owner_id)
        .order_by(models.Message.created_at.asc())
    )
    return res.scalars().all()

# Soil
async def create_soil_analysis(db: AsyncSession, user_id: int, data: dict) -> models.SoilAnalysis:
    sa = models.SoilAnalysis(
        user_id=user_id,
        land_name=data.get("land_name", ""),
        predicted_soil_type=data.get("predicted_soil_type", ""),
        recommended_crop=data.get("recommended_crop", ""),
        recommendation_score=data.get("recommendation_score", 0),
        soil_image_url=data.get("soil_image_url"),
        details=data.get("details", {}),   # ✅ langsung dict, bukan json.dumps
    )
    db.add(sa)
    await db.commit()
    await db.refresh(sa)
    return sa

async def list_soil_history(db: AsyncSession, user_id: int) -> list[models.SoilAnalysis]:
    res = await db.execute(
        select(models.SoilAnalysis)
        .where(models.SoilAnalysis.user_id == user_id)
        .order_by(models.SoilAnalysis.created_at.desc())
    )
    return res.scalars().all()
