FROM python:3.10-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    wget \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Baixa os .pth do Hugging Face
RUN git lfs install && \
    git clone https://huggingface.co/datasets/pedrom15/pthfiles && \
    mkdir -p xtts/xtts_v2 && \
    mv pthfiles/*.pth xtts/xtts_v2/

# Copiar o requirements e instalar dependências
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir TTS==0.21.1 flask flask_cors soundfile

# Copiar o restante do código
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]


