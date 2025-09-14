# LLM Backend (FastAPI + PostgreSQL + JWT)

A production-grade, modular FastAPI backend for a mobile LLM app. 
It provides auth (JWT), conversations/messages persistence, and a simple
interface (`llm_model.py`) to connect your Python LLM.

## Quickstart

1) **Python & Postgres**
   - Python 3.11+
   - PostgreSQL running locally (database `llm_backend`)

2) **Install**
```bash
cd backend
python -m venv .venv && source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env .env.local  # optional; or edit .env directly
```

3) **Run**
```bash
uvicorn app.main:app --reload
```

4) **Docs**
- Open http://127.0.0.1:8000/docs

## Plug in your model

Edit `app/llm_model.py` and implement `generate_reply` using your Python model.
The `/api/chat/{conversation_id}/message` endpoint will call it.

## Tests
```bash
pytest -q
```