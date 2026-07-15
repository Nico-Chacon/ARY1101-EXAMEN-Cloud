#!/bin/bash
# ============================================================
# Build & Push — imágenes frontend/backend hacia ECR
# Ejecutar DESPUÉS de que exista el módulo ECR en AWS
# (terraform apply -target=module.ecr)
#
# Requiere: AWS CLI configurado (aws configure o variables
# AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_SESSION_TOKEN
# ya exportadas en la sesión del Codespace)
# ============================================================
set -e

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo ">> Account ID: $ACCOUNT_ID"
echo ">> Login a ECR..."
aws ecr get-login-password --region "$AWS_REGION" | \
  docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo ">> Build & push frontend..."
cd tienda-vehiculos-frontend
docker build -t automovil-tech-frontend .
docker tag automovil-tech-frontend:latest "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/automovil-tech-frontend:latest"
docker push "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/automovil-tech-frontend:latest"
cd ..

echo ">> Build & push backend..."
cd tienda-vehiculos-backend
docker build -t automovil-tech-backend .
docker tag automovil-tech-backend:latest "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/automovil-tech-backend:latest"
docker push "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/automovil-tech-backend:latest"
cd ..

echo ">> Listo. Imágenes subidas a ECR."
