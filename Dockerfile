FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libicu-dev \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v0.5.1-beta/N_m3u8DL-RE_v0.5.1-beta_linux-x64_20251029.tar.gz -O /tmp/N_m3u8DL-RE.tar.gz \
    && tar -xzf /tmp/N_m3u8DL-RE.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/N_m3u8DL-RE \
    && rm /tmp/N_m3u8DL-RE.tar.gz

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "-m", "cantarella"]
