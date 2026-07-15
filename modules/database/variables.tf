variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "db_subnets" {
  description = "IDs de las subredes privadas para RDS"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "ID del Security Group de RDS"
  type        = string
}

variable "db_password" {
  description = "Contraseña para RDS MySQL"
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