"""Minimal embedding server with the HTTP API of Hugging Face Text Embeddings Inference (TEI).

POST /embed   {"inputs": "text" | ["text", ...], "normalize": true, "truncate": true}  ->  [[float, ...], ...]
GET  /health  200 when the model is loaded
GET  /info    model id, dimensions, max sequence length
"""
from __future__ import annotations

import os

from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer

MODEL_ID = os.environ.get("MODEL_ID", "BAAI/bge-large-en-v1.5")
BATCH_SIZE = int(os.environ.get("BATCH_SIZE", "16"))

model = SentenceTransformer(MODEL_ID, device="cpu")
app = FastAPI(title="workshop-embeddings", version="1.0")


class EmbedRequest(BaseModel):
    inputs: str | list[str]
    normalize: bool = True
    truncate: bool = True          # accepted for TEI compatibility; sentence-transformers always truncates


@app.post("/embed")
def embed(req: EmbedRequest) -> list[list[float]]:
    texts = [req.inputs] if isinstance(req.inputs, str) else req.inputs
    if not texts:
        return []
    vecs = model.encode(texts, normalize_embeddings=req.normalize, batch_size=BATCH_SIZE, show_progress_bar=False)
    return vecs.tolist()


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/info")
def info() -> dict:
    return {
        "model_id": MODEL_ID,
        "dims": getattr(model, "get_embedding_dimension", model.get_sentence_embedding_dimension)(),
        "max_input_length": model.max_seq_length,
        "device": "cpu",
    }
