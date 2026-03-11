from pathlib import Path
from typing import List, Optional
import pandas as pd
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Clinical Trial Data API")

DATA_PATH = Path(__file__).parent / "adae.csv"

try:
    df = pd.read_csv(DATA_PATH)
except FileNotFoundError:
    df = pd.DataFrame()

class AEQuery(BaseModel):
    severity: Optional[List[str]] = None
    treatment_arm: Optional[str] = None


@app.get("/")
def root():
    return {"message": "Clinical Trial Data API is running"}


@app.post("/ae-query")
def ae_query(query: AEQuery):
    if df.empty:
        raise HTTPException(status_code=500, detail="Dataset not found. Please add adae.csv.")

    filtered_df = df.copy()

    # Filter by AE severity if provided
    if query.severity:
        filtered_df = filtered_df[filtered_df["AESEV"].isin(query.severity)]

    # Filter by treatment arm if provided
    if query.treatment_arm:
        filtered_df = filtered_df[filtered_df["ACTARM"] == query.treatment_arm]

    unique_subjects = sorted(filtered_df["USUBJID"].dropna().unique().tolist())

    return {
        "count": int(len(filtered_df)),
        "unique_usubjid": unique_subjects
    }


@app.get("/subject-risk/{subject_id}")
def subject_risk(subject_id: str):
    if df.empty:
        raise HTTPException(status_code=500, detail="Dataset not found. Please add adae.csv.")

    subject_df = df[df["USUBJID"] == subject_id].copy()

    if subject_df.empty:
        raise HTTPException(status_code=404, detail=f"Subject {subject_id} not found")

    severity_scores = {
        "MILD": 1,
        "MODERATE": 3,
        "SEVERE": 5
    }

    subject_df["RISK_POINTS"] = subject_df["AESEV"].astype(str).str.upper().map(severity_scores).fillna(0)
    risk_score = int(subject_df["RISK_POINTS"].sum())

    if risk_score < 5:
        risk_category = "Low"
    elif risk_score < 15:
        risk_category = "Medium"
    else:
        risk_category = "High"

    return {
        "subject_id": subject_id,
        "risk_score": risk_score,
        "risk_category": risk_category

    }
