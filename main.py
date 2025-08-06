from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
from datetime import datetime
import os

app = FastAPI(
    title="My FastAPI Application",
    description="A simple FastAPI app with CI/CD",
    version="1.0.0"
)

# Pydantic models
class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    price: float
    created_at: Optional[datetime] = None

class ItemResponse(BaseModel):
    id: int
    name: str
    description: Optional[str]
    price: float
    created_at: datetime

# In-memory storage (production mein database use karenge)
items_db = []
next_id = 1

@app.get("/")
async def root():
    return {"message": "Welcome to FastAPI application!", "status": "running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8080)