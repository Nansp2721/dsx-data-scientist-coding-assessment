# Question 5 - Clinical Data API (FastAPI)

This folder contains a FastAPI application for serving clinical adverse event data.

## Files

- `main.py` - FastAPI application
- `adae.csv` - Input adverse event dataset

## Endpoints

### GET /
Returns a welcome message.

### POST /ae-query
Filters AE records dynamically by:
- `severity`
- `treatment_arm`

Example request body:

```json
{
  "severity": ["MILD", "MODERATE"],
  "treatment_arm": "Placebo"
}
