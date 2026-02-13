#!/bin/bash

# Auto Deploy - Run this directly on EC2 instance
echo "🚀 Starting Auto Deployment..."

# Update system
echo "📦 Updating system..."
sudo apt update && sudo apt install -y curl git docker.io

# Add user to docker group
sudo usermod -aG docker ubuntu

# Navigate to home directory
cd /home/ubuntu

# Clone repository
echo "📥 Cloning repository..."
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker stop cicd-container calculator-container || true
docker rm cicd-container calculator-container || true

# Build and run CICD container (Port 80)
echo "📦 Deploying CICD Registration Form..."
cd app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

# Build and run Calculator container (Port 3000)
echo "📦 Deploying Calculator..."
cd ../code
docker build -f Dockerfile.simple -t calculator-app .
docker run -d --name calculator-container -p 3000:80 calculator-app

echo "✅ Deployment completed successfully!"
echo ""
echo "🌐 Your Websites are LIVE:"
echo "   📋 Registration Form: http://$(curl -s ifconfig.me):80"
echo "   🧮 Calculator: http://$(curl -s ifconfig.me):3000"
echo ""
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

# Test websites
echo "🔍 Testing websites..."
sleep 5
curl -s http://localhost:80 > /dev/null && echo "✅ CICD Website: Working" || echo "❌ CICD Website: Failed"
curl -s http://localhost:3000 > /dev/null && echo "✅ Calculator Website: Working" || echo "❌ Calculator Website: Failed"
