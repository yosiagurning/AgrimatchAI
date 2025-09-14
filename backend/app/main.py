from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.database import init_models
from app.api.endpoints import api_router
from app.api import endpoints, chat_routes, soil_routes

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[origin.strip() for origin in settings.CORS_ORIGINS],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def on_startup():
    await init_models()

# Routes
app.include_router(api_router, prefix=settings.API_V1_STR)

app.include_router(endpoints.api_router)

app.include_router(chat_routes.router)
app.include_router(soil_routes.router)

@app.get("/health")
async def health():
    return {"status": "ok"}