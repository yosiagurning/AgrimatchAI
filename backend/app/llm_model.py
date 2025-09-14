# app/llm_model.py
from typing import Tuple
import httpx

LLM_ENDPOINT = "http://10.39.193.200:5678/webhook-test/c6b5f517-2c61-4529-b53c-d02359269457"

def _count_tokens(text: str) -> int:
    return max(1, len(text.split()))

def generate_reply(prompt: str, temperature: float = 0.2, max_tokens: int = 256) -> Tuple[str, int]:
    """
    Kirim prompt ke LLM endpoint dan balikan jawaban + token count.
    """
    try:
        payload = {
            "chatInput": prompt,
            "temperature": temperature,
            "max_tokens": max_tokens,
        }
        with httpx.Client(timeout=1000.0) as client:
            resp = client.post(LLM_ENDPOINT, json=payload)
            resp.raise_for_status()
            data = resp.json()

        # Sesuaikan key sesuai format response dari LLM Anda
        reply = data.get("reply") or data.get("text") or str(data)

    except Exception as e:
        reply = f"[LLM error: {e}]"

    tokens = _count_tokens(reply)
    return reply, tokens
