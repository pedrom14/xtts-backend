FROM python:3.10-slim

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    wget \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar e instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir -r requirements.txt

# Baixar os arquivos .pth do Hugging Face (json já está no repositório)
RUN mkdir -p xtts/xtts_v2 && \
    wget -O xtts/xtts_v2/model.pth https://huggingface.co/datasets/pedrom15/pthfiles/resolve/main/model.pth && \
    wget -O xtts/xtts_v2/mel_stats.pth https://huggingface.co/datasets/pedrom15/pthfiles/resolve/main/mel_stats.pth && \
    wget -O xtts/xtts_v2/dvae.pth https://huggingface.co/datasets/pedrom15/pthfiles/resolve/main/dvae.pth && \
    wget -O xtts/xtts_v2/speakers_xtts.pth https://huggingface.co/datasets/pedrom15/pthfiles/resolve/main/speakers_xtts.pth

# Copiar o restante do app
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]


