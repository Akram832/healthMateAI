from fastapi import FastAPI
from pydantic import BaseModel
import joblib

model = joblib.load('medical_classifier.joblib')

app = FastAPI()

class InputData(BaseModel):
    text: str

@app.post("/predict")
def predict(data: InputData):
    symptoms = data.text
    prediction = model.predict([symptoms])
    return {"diagnosis": prediction[0]}