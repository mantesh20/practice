#!/bin/bash

# Quick Dual Container Deployment - Run directly on EC2

echo "🚀 Deploying Dual Containers..."

# Stop existing containers
docker stop cicd-container calculator-container || true
docker rm cicd-container calculator-container || true

# Build and run CICD container (Port 80)
cd /home/ubuntu/app/CICD
docker build -f Dockerfile.cicd -t cicd-app .
docker run -d --name cicd-container -p 80:80 cicd-app

# Build and run Calculator container (Port 8080)
cd /home/ubuntu/app/code
docker build -f Dockerfile.calculator -t calculator-app .
docker run -d --name calculator-container -p 8080:80 calculator-app

echo "✅ Dual deployment complete!"
echo "📋 Registration Form: http://$(curl -s ifconfig.me):80"
echo "🧮 Calculator: http://$(curl -s ifconfig.me):8080"
echo ""
echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
