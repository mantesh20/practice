#!/bin/bash

# Dual Container Deployment Script
# CICD Container: Port 80 (Registration Form)
# Code Container: Port 8080 (Calculator)

echo "🚀 Starting Dual Container Deployment..."

# Navigate to home directory
cd /home/ubuntu

# Clone repository
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Stop and remove existing containers
echo "🛑 Stopping existing containers..."
docker stop cicd-container || true
docker rm cicd-container || true
docker stop calculator-container || true
docker rm calculator-container || true

# Build and run CICD container (Registration Form)
echo "📦 Building CICD container..."
cd app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

# Build and run Calculator container
echo "📦 Building Calculator container..."
cd ../code
docker build -f Dockerfile.calculator -t calculator-app .
docker run -d --name calculator-container -p 8080:80 calculator-app

echo "✅ Dual deployment completed!"
echo ""
echo "🌐 Access Points:"
echo "   📋 Registration Form: http://$(curl -s ifconfig.me):80"
echo "   🧮 Calculator: http://$(curl -s ifconfig.me):8080"
echo ""
echo "📋 Container Status:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"
