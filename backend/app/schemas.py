from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, EmailStr, Field

# Auth
class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"

class TokenPayload(BaseModel):
    sub: str
    exp: int

class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str = Field(min_length=6)

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserOut(UserBase):
    id: int
    is_active: bool
    created_at: datetime
    phone: Optional[str] = None

    class Config:
        from_attributes = True

# Chat / Conversation
class ConversationBase(BaseModel):
    title: Optional[str] = "New Chat"

class ConversationCreate(ConversationBase):
    pass

class ConversationOut(ConversationBase):
    id: int
    owner_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class MessageBase(BaseModel):
    role: str
    content: str

class MessageCreate(MessageBase):
    pass

class MessageOut(MessageBase):
    id: int
    conversation_id: int
    token_count: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True

class ChatRequest(BaseModel):
    content: str
    # model params you might want to pass to your LLM
    temperature: float = 0.2
    max_tokens: int = 256

class ChatResponse(BaseModel):
    message: MessageOut

class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(default=None, alias="name")
    email: Optional[EmailStr] = None
    phone: Optional[str] = None

    class Config:
        populate_by_name = True

class PasswordUpdate(BaseModel):
    old_password: str
    new_password: str

class SoilAnalysisOut(BaseModel):
    id: int
    land_name: str
    predicted_soil_type: str
    recommended_crop: str
    recommendation_score: int
    soil_image_url: Optional[str]
    details: dict
    created_at: datetime

    class Config:
        from_attributes = True
