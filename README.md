# legacy_codebase_demo

Workshop notebook **"Make Legacy Codebase Searchable"** – `legacy-codebase.ipynb`, built on COBOL/CICS sources from [AWS CardDemo](aws-mainframe-modernization-carddemo/).

## Start the local backends (Docker Compose)

The notebook itself runs on your machine (Jupyter / IDE). Only the two backends run in Docker:

| Service | Purpose | URL |
|---|---|---|
| `qdrant` | local vector database (persistent volume) | <http://localhost:6333/dashboard> |
| `embeddings` | local embedding model server – `BAAI/bge-large-en-v1.5` on CPU, TEI-compatible API | <http://localhost:8080/health> |

```bash
docker compose up --build -d        # first build downloads CPU torch; the model comes from ~/.cache/huggingface or is downloaded once (≈1.3 GB)
docker compose logs -f embeddings   # wait for "Application startup complete"
curl -s localhost:8080/info         # {"model_id": "BAAI/bge-large-en-v1.5", "dims": 1024, ...}
docker compose down                 # stop (add -v to drop the Qdrant volume)
```

Then open `legacy-codebase.ipynb` and run it top to bottom. The Setup cell detects both services via `EMBED_URL` (default `http://localhost:8080`) and `QDRANT_URL` (default `http://localhost:6333`).

Optional environment variables (e.g. in `.env`): `HF_CACHE_DIR` (default `~/.cache/huggingface`), `HF_HUB_OFFLINE=1` once the model is cached, `EMBED_MODEL` to serve a different Sentence-Transformers model.

**Port already in use?** If another Qdrant (or anything else) already listens on 6333/8080, pick other host ports and tell the notebook about them:

```bash
QDRANT_PORT=6335 QDRANT_GRPC_PORT=6336 EMBED_PORT=8081 docker compose up --build -d
QDRANT_URL=http://localhost:6335 EMBED_URL=http://localhost:8081 jupyter lab
```

## Without Docker

If the services are not reachable the notebook falls back automatically: embeddings are computed in-process with `sentence-transformers` (needs `pip install sentence-transformers`) and Qdrant runs embedded in-process (`:memory:`). Results are identical, only the setup takes longer.
