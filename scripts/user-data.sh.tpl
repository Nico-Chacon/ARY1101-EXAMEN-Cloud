#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# ---------------------------------------------------------
# Bootstrap EC2 — Automóvil Tech (tienda-vehiculos)
# Generado por Terraform (templatefile) — NO editar a mano
# ---------------------------------------------------------

yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
usermod -a -G docker ssm-user

# Docker Compose plugin
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Login a ECR usando el rol IAM de la instancia (LabInstanceProfile)
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${aws_region}.amazonaws.com

# Variables de entorno para el backend
cat > .env << ENVEOF
DB_HOST=${db_host}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
ENVEOF

# docker-compose.yml apuntando a las imágenes reales en ECR
cat > docker-compose.yml << COMPOSEEOF
services:
  frontend:
    image: ${frontend_image}
    container_name: tienda-vehiculos-frontend
    ports:
      - "80:80"
    restart: always
    depends_on:
      - backend

  backend:
    image: ${backend_image}
    container_name: tienda-vehiculos-backend
    environment:
      DB_HOST: "${db_host}"
      DB_USER: "${db_user}"
      DB_PASSWORD: "${db_password}"
      DB_NAME: "${db_name}"
      DB_PORT: "3306"
    ports:
      - "3001:3001"
    restart: always
COMPOSEEOF

chown -R ec2-user:ec2-user /home/ec2-user/app

# Pull explícito (útil para ver el log si algo falla) + arranque
docker-compose pull || exit 1
docker-compose up -d || exit 1

docker ps -a

echo "Automovil Tech user-data setup completed successfully"
