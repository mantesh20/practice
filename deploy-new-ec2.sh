#!/bin/bash

# Deploy to New EC2 Instance - Run this directly on EC2
echo "🚀 Deploying to New EC2 Instance..."
KEY_FILE="Manteshkeypair.pem"

# Navigate to home directory
cd /home/ubuntu

# Clone repository
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    sudo apt update
    sudo apt install docker.io -y
    sudo usermod -aG docker ubuntu
    echo "⚠️  Please log out and log back in for Docker permissions"
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker stop cicd-container calculator-container || true
docker rm cicd-container calculator-container || true

# Build and run CICD container (Port 80)
echo "📦 Building CICD container..."
cd app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

# Build and run Calculator container (Port 8080)
echo "📦 Building Calculator container..."
cd ../code
docker build -f Dockerfile.simple -t calculator-app .
docker run -d --name calculator-container -p 8080:80 calculator-app

echo "✅ Dual deployment completed!"
echo ""
echo "🌐 Access Points:"
echo "   📋 Registration Form: http://$(curl -s ifconfig.me):80"
echo "   🧮 Calculator: http://$(curl -s ifconfig.me):8080"
echo ""
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
