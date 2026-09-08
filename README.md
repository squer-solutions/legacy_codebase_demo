# legacy_codebase_demo

Workshop notebook **"Make Legacy Codebase Searchable"** – `legacy-codebase.ipynb`, built on COBOL/CICS sources from [AWS CardDemo](aws-mainframe-modernization-carddemo/).

## Run with Docker Compose (recommended for the workshop)

```bash
docker compose --profile warmup run --rm warmup   # once: cache the embedding model (≈1.3 GB) in ~/.cache/huggingface
docker compose up --build                          # Qdrant + JupyterLab
```

Then open <http://localhost:8888/?token=workshop> and run `legacy-codebase.ipynb` top to bottom.

| Service | Purpose | URL |
|---|---|---|
| `qdrant` | local vector database (persistent volume) | <http://localhost:6333/dashboard> |
| `notebook` | JupyterLab with the local embedding model (`BAAI/bge-large-en-v1.5`, CPU) | <http://localhost:8888> |
| `warmup` | one-shot model download (profile `warmup`) | – |

Optional environment variables (e.g. via `.env`): `JUPYTER_TOKEN` (default `workshop`), `HF_CACHE_DIR` (default `~/.cache/huggingface`), `HF_HUB_OFFLINE=1` once the model is cached, `ANTHROPIC_API_KEY` for the optional LLM bonus cell.

## Run without Docker

The notebook also works in a plain local Python environment: the first cell installs missing packages, and if no Qdrant server is reachable on `localhost:6333` it falls back to Qdrant's embedded in-process mode automatically.
