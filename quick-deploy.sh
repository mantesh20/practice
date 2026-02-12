#!/bin/bash

# Quick Deploy Script - Run directly on EC2 to deploy code folder

echo "Deploying code folder to Docker..."

# Navigate to code directory
cd /home/ubuntu/app/code

# Build and run the Docker container
docker build -f Dockerfile.calculator -t my-app .
docker stop my-app-container || true
docker rm my-app-container || true
docker run -d --name my-app-container -p 80:80 my-app

echo "✅ Deployment completed!"
echo "🌐 Calculator available at: http://$(curl -s ifconfig.me)"
echo "📱 Direct calculator link: http://$(curl -s ifconfig.me)/calculator.html"

# Show running container
echo ""
echo "📋 Container status:"
docker ps | grep my-app-container
