#!/bin/bash

# CICD Only Deployment - Run this directly on EC2 instance
echo "🚀 Deploying CICD Website Only..."

# Update system
echo "📦 Updating system..."
sudo apt update && sudo apt install -y curl git docker.io
sudo usermod -aG docker ubuntu

# Navigate to home directory
cd /home/ubuntu

# Clone repository
echo "📥 Cloning repository..."
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker stop cicd-container || true
docker rm cicd-container || true

# Build and run CICD container (Port 80)
echo "📦 Building CICD Registration Form..."
cd app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

echo "✅ CICD deployment completed!"
echo ""
echo "🌐 CICD Registration Form: http://$(curl -s ifconfig.me):80"
echo ""
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

# Test website
echo "🔍 Testing CICD website..."
sleep 3
curl -s http://localhost:80 > /dev/null && echo "✅ CICD Website: Working" || echo "❌ CICD Website: Failed"
