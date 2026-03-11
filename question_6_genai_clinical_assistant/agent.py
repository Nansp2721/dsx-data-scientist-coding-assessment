from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Any
import pandas as pd


@dataclass
class LLMResult:
    target_column: str
    filter_value: str


class ClinicalTrialDataAgent:
    def __init__(self, csv_path: str = "adae.csv"):
        data_path = Path(__file__).parent / csv_path
        self.df = pd.read_csv(data_path)

        # Schema description for the "LLM"
        self.schema = {
            "AESEV": "Adverse event severity or intensity (e.g. MILD, MODERATE, SEVERE)",
            "AETERM": "Adverse event term or condition (e.g. Headache, Nausea)",
            "AESOC": "Body system or system organ class (e.g. CARDIAC DISORDERS)",
            "ACTARM": "Treatment arm (e.g. Placebo)"
        }

    def parse_question(self, question: str) -> LLMResult:
        """
        Mock LLM logic:
        Converts a natural language question into a structured column + value.
        """
        q = question.lower()

        # Severity / intensity questions
        if "severity" in q or "intensity" in q or "mild" in q or "moderate" in q or "severe" in q:
            if "mild" in q:
                return LLMResult(target_column="AESEV", filter_value="MILD")
            if "moderate" in q:
                return LLMResult(target_column="AESEV", filter_value="MODERATE")
            if "severe" in q:
                return LLMResult(target_column="AESEV", filter_value="SEVERE")

        # Body system / SOC questions
        if "cardiac" in q:
            return LLMResult(target_column="AESOC", filter_value="CARDIAC DISORDERS")
        if "skin" in q:
            return LLMResult(target_column="AESOC", filter_value="SKIN AND SUBCUTANEOUS TISSUE DISORDERS")

        # Treatment arm questions
        if "placebo" in q:
            return LLMResult(target_column="ACTARM", filter_value="Placebo")

        # AE term examples
        if "headache" in q:
            return LLMResult(target_column="AETERM", filter_value="Headache")
        if "nausea" in q:
            return LLMResult(target_column="AETERM", filter_value="Nausea")

        # Default fallback
        return LLMResult(target_column="AETERM", filter_value="Headache")

    def run_query(self, question: str) -> Dict[str, Any]:
        parsed = self.parse_question(question)

        column = parsed.target_column
        value = parsed.filter_value

        if column not in self.df.columns:
            raise ValueError(f"Column {column} not found in dataset.")

        if column in ["AESEV", "AESOC", "ACTARM"]:
            filtered_df = self.df[
                self.df[column].astype(str).str.upper() == value.upper()
            ]
        else:
            filtered_df = self.df[
                self.df[column].astype(str).str.upper().str.contains(value.upper(), na=False)
            ]

        unique_subjects = sorted(filtered_df["USUBJID"].dropna().unique().tolist())

        return {
            "question": question,
            "parsed_output": {
                "target_column": column,
                "filter_value": value
            },
            "unique_subject_count": len(unique_subjects),
            "matching_usubjid": unique_subjects
        }