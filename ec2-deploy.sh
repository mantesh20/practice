#!/bin/bash

# EC2 Deployment Script - Run this directly on EC2 instance

echo "Starting deployment..."

# Navigate to home directory
cd /home/ubuntu

# Clone the repository
git clone https://github.com/mantesh20/practice.git app || (cd app && git pull origin main)

# Navigate to the code directory
cd app/code

# Build and run the Docker container
docker build -f Dockerfile.calculator -t my-app .
docker stop my-app-container || true
docker rm my-app-container || true
docker run -d --name my-app-container -p 80:80 my-app

echo "Deployment completed successfully!"
echo "Your app should be available at: http://$(curl -s ifconfig.me)"
