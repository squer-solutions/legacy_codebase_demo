# JupyterLab image for the workshop notebook: Python 3.12, CPU-only torch, local embedding model, Qdrant client.
FROM python:3.12-slim

ENV PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/root/.cache/huggingface \
    TOKENIZERS_PARALLELISM=false

# git/curl for convenience; Node.js + Claude Code CLI for the optional LLM bonus cell (ask_claude_code -> `claude -p`)
RUN apt-get update \
 && apt-get install -y --no-install-recommends git curl ca-certificates nodejs npm \
 && npm install -g @anthropic-ai/claude-code \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --extra-index-url https://download.pytorch.org/whl/cpu -r /tmp/requirements.txt

WORKDIR /workspace
EXPOSE 8888

# JUPYTER_TOKEN is picked up from the environment (see docker-compose.yml)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.root_dir=/workspace"]
