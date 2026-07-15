output "trail_arn" {
  description = "ARN del CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "trail_name" {
  description = "Nombre del trail"
  value       = aws_cloudtrail.main.name
}

output "log_bucket_name" {
  description = "Nombre del bucket S3 con logs de auditoría"
  value       = aws_s3_bucket.cloudtrail.bucket
}
