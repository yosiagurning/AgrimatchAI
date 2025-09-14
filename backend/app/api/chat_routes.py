from fastapi import APIRouter
from app.services.llm_service import LLMService

router = APIRouter(prefix="/chat", tags=["chat"])
llm = LLMService()

@router.post("/")
def chat(message: str):
    reply = llm.chat(message)
    return {"reply": reply}
