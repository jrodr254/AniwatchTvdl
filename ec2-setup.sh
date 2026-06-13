#!/bin/bash

# Install dependencies
sudo apt update
sudo apt install -y python3 python3-pip git wget ffmpeg libicu-dev

# Clone the repo to /opt/AniwatchTvdl
sudo rm -rf /opt/AniwatchTvdl
sudo git clone https://github.com/jrodr254/AniwatchTvdl.git /opt/AniwatchTvdl

# Install Python requirements
sudo pip3 install -r /opt/AniwatchTvdl/requirements.txt

# Download N_m3u8DL-RE binary
sudo wget -O /usr/local/bin/N_m3u8DL-RE "https://github.com/nilaoda/N_m3u8DL-RE/releases/latest/download/N_m3u8DL-RE_linux_x64"
sudo chmod +x /usr/local/bin/N_m3u8DL-RE

# Prompt for environment variables and save them to /etc/aniwatchtvdl.env
read -p "Enter API_ID: " API_ID
read -p "Enter API_HASH: " API_HASH
read -p "Enter BOT_TOKEN: " BOT_TOKEN
read -p "Enter MONGO_URL: " MONGO_URL
read -p "Enter OWNER_ID: " OWNER_ID
read -p "Enter MAIN_CHANNEL: " MAIN_CHANNEL
read -p "Enter LOG_CHANNEL: " LOG_CHANNEL

sudo tee /etc/aniwatchtvdl.env > /dev/null <<EOF
API_ID=$API_ID
API_HASH=$API_HASH
BOT_TOKEN=$BOT_TOKEN
MONGO_URL=$MONGO_URL
OWNER_ID=$OWNER_ID
MAIN_CHANNEL=$MAIN_CHANNEL
LOG_CHANNEL=$LOG_CHANNEL
EOF

# Create a systemd service for the bot
sudo tee /etc/systemd/system/aniwatchtvdl.service > /dev/null <<EOF
[Unit]
Description=AniwatchTvdl Telegram Bot
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/AniwatchTvdl
EnvironmentFile=/etc/aniwatchtvdl.env
ExecStart=/usr/bin/python3 -m cantarella
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable aniwatchtvdl
sudo systemctl start aniwatchtvdl

echo "AniwatchTvdl bot setup complete and service started."
