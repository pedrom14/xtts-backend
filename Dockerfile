FROM python:3.10-slim

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar os requirements
COPY requirements.txt . 
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o restante do projeto (inclusive xtts/xtts_v2 com .pth e .json)
COPY . .

# ⚠️ IMPORTANTE: Git LFS precisa ser inicializado e os arquivos puxados
RUN git lfs install && git lfs pull

EXPOSE 5000

# Comando para iniciar o app
CMD ["python", "app.py"]




