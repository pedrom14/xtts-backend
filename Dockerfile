FROM python:3.10-slim

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git-lfs \
    ffmpeg \
    libsndfile1 \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia e instala dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir torch==2.5.1
RUN pip install --no-cache-dir -r requirements.txt

# Baixa os arquivos .pth
RUN git lfs install && \
    git clone https://huggingface.co/datasets/pedrom15/pthfiles && \
    mkdir -p xtts/xtts_v2 && \
    mv pthfiles/*.pth xtts/xtts_v2/

# Verifica se os arquivos estão no lugar
RUN ls -lh xtts/xtts_v2/

# Copia os arquivos restantes do app, incluindo os .json
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]

