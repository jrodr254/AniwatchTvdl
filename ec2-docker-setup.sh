#!/bin/bash

# Function to install Docker and Docker Compose
install_docker() {
    if ! command -v docker &> /dev/null
    then
        echo "Docker not found. Installing Docker..."
        sudo rm -f /etc/apt/sources.list.d/docker.list
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
          "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \\
          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo usermod -aG docker $USER
        newgrp docker
        # Verify docker command is available after newgrp
        if ! command -v docker &> /dev/null; then
            echo "Error: Docker command not found after newgrp. Please log out and log back in manually."
            exit 1
        fi
        echo "Docker installed successfully."

    else
        echo "Docker is already installed."
    fi

    if ! command -v docker compose &> /dev/null
    then
        echo "Docker Compose not found. Installing Docker Compose..."
        sudo apt-get install -y docker-compose-plugin
        echo "Docker Compose installed successfully."
    else
        echo "Docker Compose is already installed."
    fi
}

# Install Docker and Docker Compose
install_docker

# Clone the repo if not already present
if [ ! -d "AniwatchTvdl" ]; then
    echo "Cloning the AniwatchTvdl repository..."
    git clone https://github.com/jrodr254/AniwatchTvdl.git
    cd AniwatchTvdl
else
    echo "AniwatchTvdl repository already exists. Skipping clone."
    cd AniwatchTvdl
fi

# Prompt for environment variables and create .env file
echo "Creating .env file..."
read -p "Enter API_ID: " API_ID
read -p "Enter API_HASH: " API_HASH
read -p "Enter BOT_TOKEN: " BOT_TOKEN
read -p "Enter MONGO_URL: " MONGO_URL
read -p "Enter OWNER_ID: " OWNER_ID
read -p "Enter MAIN_CHANNEL: " MAIN_CHANNEL
read -p "Enter LOG_CHANNEL: " LOG_CHANNEL

cat << EOF > .env
API_ID=$API_ID
API_HASH=$API_HASH
BOT_TOKEN=$BOT_TOKEN
MONGO_URL=$MONGO_URL
OWNER_ID=$OWNER_ID
MAIN_CHANNEL=$MAIN_CHANNEL
LOG_CHANNEL=$LOG_CHANNEL
EOF

echo ".env file created."

# Run docker-compose
echo "Starting bot with docker-compose..."
docker compose up -d

echo "Setup complete! The bot is running in the background."
