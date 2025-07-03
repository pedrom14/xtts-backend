# Dockerfile
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git-lfs \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia os arquivos de dependências
COPY requirements.txt .
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir -r requirements.txt

# Copia os arquivos do projeto primeiro (inclusive JSON)
COPY . .

# Cria pasta de modelo e baixa os .pth do Hugging Face
RUN git lfs install && \
    git clone https://huggingface.co/datasets/pedrom15/pthfiles && \
    mkdir -p xtts/xtts_v2 && \
    mv pthfiles/*.pth xtts/xtts_v2/

# Verifica conteúdo final da pasta do modelo
RUN ls -lh xtts/xtts_v2/

EXPOSE 5000
CMD ["python", "app.py"]
