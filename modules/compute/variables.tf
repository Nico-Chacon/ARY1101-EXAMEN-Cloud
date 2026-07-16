variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "IDs de las subredes privadas"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN del Target Group del ALB"
  type        = string
}

variable "ec2_sg_id" {
  description = "ID del Security Group de EC2"
  type        = string
}

variable "ami_id" {
  description = "ID de la AMI personalizada"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Nombre del Key Pair EC2 para acceso SSH (creado manualmente en la consola AWS)"
  type        = string
  default     = "Examen-cloud"
}

variable "app_version" {
  description = "Versión de la aplicación"
  type        = string
  default     = "v1.0.0"
}

variable "aws_region" {
  description = "Región AWS (para login a ECR)"
  type        = string
}

variable "account_id" {
  description = "Account ID de AWS (para armar la URL de ECR)"
  type        = string
}

variable "db_host" {
  description = "Endpoint de RDS"
  type        = string
}

variable "db_user" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Password de la base de datos"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "ecr_frontend_repo_url" {
  description = "URL del repositorio ECR del frontend"
  type        = string
}

variable "ecr_backend_repo_url" {
  description = "URL del repositorio ECR del backend"
  type        = string
}

variable "db_init_sql_b64" {
  description = "Contenido de init.sql codificado en base64 (para cargarlo automáticamente al arrancar)"
  type        = string
  sensitive   = true
}