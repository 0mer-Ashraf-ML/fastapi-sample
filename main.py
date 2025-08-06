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

@app.get("/")
async def root():
    return {"message": "Welcome to FastAPI application!", "status": "running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
