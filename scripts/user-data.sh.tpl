#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

# ---------------------------------------------------------
# Bootstrap EC2 — Automóvil Tech (tienda-vehiculos)
# Generado por Terraform (templatefile) — NO editar a mano
# ---------------------------------------------------------

yum update -y
yum install -y docker mariadb105

systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
usermod -a -G docker ssm-user

# Docker Compose plugin
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# -----------------------------------------------------------
# Esperar a que RDS esté disponible (hasta ~5 min)
# -----------------------------------------------------------
for i in $(seq 1 30); do
  if mysql -h "${db_host}" -u "${db_user}" -p"${db_password}" -e "SELECT 1;" > /dev/null 2>&1; then
    echo "RDS disponible."
    break
  fi
  echo "Esperando RDS... intento $i/30"
  sleep 10
done

# -----------------------------------------------------------
# Cargar init.sql SOLO si la tabla aún no tiene datos
# (evita duplicar filas cada vez que el ASG lanza una instancia
#  nueva, por escalado o por reemplazo)
# -----------------------------------------------------------
echo "${db_init_sql_b64}" | base64 -d > /tmp/init.sql

ROW_COUNT=$(mysql -h "${db_host}" -u "${db_user}" -p"${db_password}" -N -B \
  -e "SELECT COUNT(*) FROM ${db_name}.vehiculos;" 2>/dev/null || echo "0")

if [ "$ROW_COUNT" = "0" ]; then
  echo "Tabla vacía o inexistente: cargando init.sql..."
  mysql -h "${db_host}" -u "${db_user}" -p"${db_password}" < /tmp/init.sql \
    && echo "init.sql cargado correctamente" \
    || echo "ADVERTENCIA: init.sql falló (se continúa igual, revisar /var/log/user-data.log)"
else
  echo "La tabla ya tiene $ROW_COUNT filas, se omite init.sql"
fi

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
      backend:
        condition: service_healthy

  backend:
    image: ${backend_image}
    container_name: tienda-vehiculos-backend
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3001/api/health"]
      interval: 10s
      timeout: 5s
      retries: 10
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
