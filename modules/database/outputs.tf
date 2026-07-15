output "db_endpoint" {
  description = "Endpoint de RDS MySQL (incluye puerto, ej: host:3306)"
  value       = aws_db_instance.mysql.endpoint
}

output "db_address" {
  description = "Host de RDS MySQL (sin puerto, para usar en DB_HOST de la app)"
  value       = aws_db_instance.mysql.address
}

output "db_identifier" {
  description = "Identificador de la base de datos"
  value       = aws_db_instance.mysql.identifier
}

output "db_arn" {
  description = "ARN de la base de datos"
  value       = aws_db_instance.mysql.arn
}

output "db_port" {
  description = "Puerto de la base de datos"
  value       = aws_db_instance.mysql.port
}

output "db_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.mysql.db_name
}

output "db_username" {
  description = "Usuario administrador"
  value       = aws_db_instance.mysql.username
}