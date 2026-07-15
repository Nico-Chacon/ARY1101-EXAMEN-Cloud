output "alb_dns_name" {
  description = "DNS del Application Load Balancer — pegar en el browser para ver la app"
  value       = module.loadbalancer.alb_dns_name
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = module.networking.vpc_id
}

output "db_endpoint" {
  description = "Endpoint de RDS MySQL"
  value       = module.database.db_endpoint
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = module.compute.asg_name
}

output "sns_topic_arn" {
  description = "ARN del topic SNS para alertas"
  value       = module.monitoring.sns_topic_arn
}

output "cloudtrail_bucket" {
  description = "Bucket S3 con logs de auditoría CloudTrail"
  value       = module.cloudtrail.log_bucket_name
}

output "cloudtrail_trail_name" {
  description = "Nombre del Trail de CloudTrail"
  value       = module.cloudtrail.trail_name
}

output "ecr_frontend_repo_url" {
  description = "URL del repositorio ECR del frontend (para docker push)"
  value       = module.ecr.frontend_repo_url
}

output "ecr_backend_repo_url" {
  description = "URL del repositorio ECR del backend (para docker push)"
  value       = module.ecr.backend_repo_url
}

output "account_id" {
  description = "Account ID de AWS"
  value       = data.aws_caller_identity.current.account_id
}
