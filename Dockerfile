# Dockerfile
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    git-lfs \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia os arquivos do projeto
COPY requirements.txt .
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir -r requirements.txt

# Baixa os .pth do Hugging Face
RUN git lfs install && \
    git clone https://huggingface.co/datasets/pedrom15/pthfiles && \
    mkdir -p xtts/xtts_v2 && \
    mv pthfiles/*.pth xtts/xtts_v2/


# Copia restante do código
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]
