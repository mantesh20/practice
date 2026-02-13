#!/bin/bash

# Quick Deploy - Run this directly on EC2 instance
echo "🚀 Starting Deployment..."

# Clone repository
cd /home/ubuntu
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Stop existing containers
docker stop cicd-container calculator-container || true
docker rm cicd-container calculator-container || true

# Deploy CICD (Port 80)
echo "📦 Deploying CICD..."
cd app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

# Deploy Calculator (Port 3000)
echo "📦 Deploying Calculator..."
cd ../code
docker build -f Dockerfile.simple -t calculator-app .
docker run -d --name calculator-container -p 3000:80 calculator-app

echo "✅ Deployment completed!"
echo "📋 Registration Form: http://$(curl -s ifconfig.me):80"
echo "🧮 Calculator: http://$(curl -s ifconfig.me):3000"
echo ""
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
