#!/bin/bash

# Manual Deployment Script - Run this directly on EC2 instance
echo "🚀 Starting Manual Deployment..."

# Navigate to home directory
cd /home/ubuntu

# Copy code from local machine to EC2 instance
scp -i Manteshkeypair.pem -r code/ $USER@$EC2_IP:/home/ubuntu/

# Clone or update repository
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

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
