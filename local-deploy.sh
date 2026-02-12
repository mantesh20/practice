#!/bin/bash

# EC2 Deployment Script
# Usage: ./local-deploy.sh <EC2_IP>

EC2_IP=$1
KEY_FILE="newone.pem"
USER="ubuntu"

if [ -z "$EC2_IP" ]; then
    echo "Usage: ./local-deploy.sh <EC2_IP>"
    exit 1
fi

echo "Deploying to EC2 instance: $EC2_IP"

# Copy files to EC2
scp -i $KEY_FILE -r CICD/ $USER@$EC2_IP:/home/ubuntu/

# Deploy on EC2
ssh -i $KEY_FILE $USER@$EC2_IP << 'EOF'
cd /home/ubuntu/CICD
docker build -t my-app .
docker stop my-app-container || true
docker rm my-app-container || true
docker run -d --name my-app-container -p 80:80 my-app
echo "Deployment completed successfully!"
EOF

echo "Deployment finished!"
