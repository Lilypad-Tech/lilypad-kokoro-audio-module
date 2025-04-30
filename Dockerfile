# Base stage with common dependencies
FROM python:3.10-slim-bullseye AS base

# Set the working directory in the container
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl

# Update pip and install base Python packages with specific numpy version
RUN pip install --no-cache-dir --upgrade pip

# Install dependencies
RUN pip install --no-cache-dir \
    kokoro \
    huggingface_hub==0.30.1 \
    scipy \
    torch

# Create directories for model cache
RUN mkdir -p /root/.cache/huggingface

RUN python -c "import scipy; from kokoro import KPipeline; import torch; import os; \
    pipeline = KPipeline(lang_code='a')"

RUN mkdir -p /root/.cache/huggingface/hub/models--hexgrad--Kokoro-82M/snapshots/f3ff3571791e39611d31c381e3a41a3af07b4987/voices

# Download the voice files
RUN curl -L -o /root/.cache/huggingface/hub/models--hexgrad--Kokoro-82M/snapshots/f3ff3571791e39611d31c381e3a41a3af07b4987/voices/af_heart.pt https://huggingface.co/hexgrad/Kokoro-82M/resolve/main/voices/af_heart.pt
RUN curl -L -o /root/.cache/huggingface/hub/models--hexgrad--Kokoro-82M/snapshots/f3ff3571791e39611d31c381e3a41a3af07b4987/voices/am_fenrir.pt https://huggingface.co/hexgrad/Kokoro-82M/resolve/main/voices/am_fenrir.pt
RUN curl -L -o /root/.cache/huggingface/hub/models--hexgrad--Kokoro-82M/snapshots/f3ff3571791e39611d31c381e3a41a3af07b4987/voices/af_bella.pt https://huggingface.co/hexgrad/Kokoro-82M/resolve/main/voices/af_bella.pt
RUN curl -L -o /root/.cache/huggingface/hub/models--hexgrad--Kokoro-82M/snapshots/f3ff3571791e39611d31c381e3a41a3af07b4987/voices/am_puck.pt https://huggingface.co/hexgrad/Kokoro-82M/resolve/main/voices/am_puck.pt

# Create output directory
RUN mkdir -p /outputs && chmod 777 /outputs

# Production stage
FROM base AS production

# Copy the Python script into the container
COPY run_kokoro.py /workspace/run_kokoro.py
RUN chmod +x /workspace/run_kokoro.py

# Set default environment variables
ENV DEFAULT_PROMPT="In a world increasingly shaped by technology, the pace of innovation shows no sign of slowing. From artificial intelligence and blockchain to quantum computing and biotechnology, every field is evolving rapidly, promising to reshape how we live, work, and connect."
ENV DEFAULT_VOICE="heart"

VOLUME /workspace/outputs

# Set the entrypoint to run the Python script
ENTRYPOINT ["python", "/workspace/run_kokoro.py"]