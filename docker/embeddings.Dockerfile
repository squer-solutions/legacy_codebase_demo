# Local embedding model server (TEI-compatible HTTP API) – CPU only, multi-arch (arm64 + amd64).
FROM python:3.12-slim

ENV PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/root/.cache/huggingface \
    TOKENIZERS_PARALLELISM=false \
    MODEL_ID=BAAI/bge-large-en-v1.5

COPY requirements.txt /tmp/requirements.txt
RUN pip install --extra-index-url https://download.pytorch.org/whl/cpu -r /tmp/requirements.txt

WORKDIR /app
COPY embeddings_server.py /app/embeddings_server.py

EXPOSE 80
CMD ["uvicorn", "embeddings_server:app", "--host", "0.0.0.0", "--port", "80"]
