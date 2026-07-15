output "frontend_repo_url" {
  description = "URL del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_repo_url" {
  description = "URL del repositorio ECR del backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_repo_name" {
  value = aws_ecr_repository.frontend.name
}

output "backend_repo_name" {
  value = aws_ecr_repository.backend.name
}
