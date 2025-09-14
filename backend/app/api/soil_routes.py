from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.services.cnn_service import CNNService
from app.database import get_db
from app import crud, models
from app.schemas import SoilAnalysisOut
from app.core.security import get_current_user
import shutil, os, uuid

router = APIRouter(prefix="/api/soil", tags=["soil"])
cnn = CNNService("app/models/best.pt")

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)


@router.post("/analyze", response_model=SoilAnalysisOut)
async def analyze_soil(
    land_name: str = Form("Lahan Baru"),
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    try:
        # simpan file ke folder uploads permanen
        file_ext = os.path.splitext(file.filename)[-1]
        filename = f"scaled_{uuid.uuid4().hex}{file_ext}"
        file_path = os.path.join(UPLOAD_DIR, filename)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        file_size = os.path.getsize(file_path)
        print(f"✅ File saved: {file_path} ({file_size} bytes), content_type={file.content_type}")

        if file_size == 0:
            raise HTTPException(status_code=400, detail="Uploaded file is empty")

        # prediksi cnn
        prediction = cnn.predict(file_path)

        # mapping hasil CNN
        predicted_soil_type = ["Lempung", "Berpasir", "Gambut"][prediction]
        recommended_crop = ["Padi", "Jagung", "Kopi"][prediction]
        recommendation_score = 80 + prediction  # contoh skor

        result = {
            "land_name": land_name,
            "predicted_soil_type": predicted_soil_type,
            "recommended_crop": recommended_crop,
            "recommendation_score": recommendation_score,
            "soil_image_url": f"/uploads/{filename}",  # path permanen
            "details": {"cnn_class": prediction},       # ✅ langsung dict
        }

        # simpan ke DB
        sa = models.SoilAnalysis(
            user_id=current_user.id,
            **result
        )
        db.add(sa)
        await db.commit()
        await db.refresh(sa)

        return sa

    except Exception as e:
        print(f"❌ Prediction error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/history", response_model=list[SoilAnalysisOut])
async def get_history(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    return await crud.list_soil_history(db, current_user.id)
