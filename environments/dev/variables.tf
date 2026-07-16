variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "automovil-tech"
}

variable "owner_name" {
  description = "Tu nombre (para el tag Owner)"
  type        = string
  default     = "cambia-tu-nombre"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ami_id" {
  description = "ID de la AMI personalizada (dejar vacío para usar Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Nombre del Key Pair EC2 (créalo en la consola AWS antes del apply)"
  type        = string
  default     = "Examen-cloud"
}

variable "db_password" {
  description = "Contraseña para RDS MySQL (pásala vía TF_VAR_db_password, NUNCA la commitees)"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos (debe coincidir con init.sql)"
  type        = string
  default     = "tienda_vehiculos"
}

variable "db_username" {
  description = "Usuario administrador de RDS"
  type        = string
  default     = "admin"
}

variable "email_sns" {
  description = "Correo para notificaciones SNS (Budgets + CloudWatch)"
  type        = string
}

variable "app_version" {
  description = "Versión de la aplicación"
  type        = string
  default     = "v1.0.0"
}

# ----------------------------------------------------------
# Variables de control financiero
# ----------------------------------------------------------
variable "monthly_budget_usd" {
  description = "Presupuesto mensual total en USD"
  type        = string
  default     = "100"
}

variable "ec2_budget_usd" {
  description = "Presupuesto mensual para EC2 en USD"
  type        = string
  default     = "40"
}

variable "rds_budget_usd" {
  description = "Presupuesto mensual para RDS en USD"
  type        = string
  default     = "30"
}
