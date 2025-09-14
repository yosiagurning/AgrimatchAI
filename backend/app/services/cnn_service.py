from ultralytics import YOLO

class CNNService:
    def __init__(self, model_path: str):
        try:
            self.model = YOLO(model_path)
            print(f"✅ YOLO model loaded from {model_path}")
            print(f"✅ Model classes: {self.model.names}")
        except Exception as e:
            print(f"❌ Failed to load YOLO model: {e}")
            raise

    def predict(self, img_path: str) -> int:
        try:
            results = self.model.predict(img_path, verbose=False, conf=0.1)

            if not results or len(results) == 0:
                raise ValueError("No prediction results returned")

            res = results[0]

            # Jika ada box → ambil kelas pertama
            if res.boxes is not None and len(res.boxes) > 0:
                top_idx = int(res.boxes.cls[0].item())
                print(f"✅ Detection result: class={top_idx}, boxes={len(res.boxes)}")
                return top_idx

            # Jika tidak ada box, fallback ke kelas default (misalnya 0)
            print("⚠️ No boxes detected, fallback to class 0")
            return 0

        except Exception as e:
            print(f"❌ Prediction error: {e}")
            raise
