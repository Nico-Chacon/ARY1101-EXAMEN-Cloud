output "auditor_role_arn" {
  description = "ARN del rol de auditor"
  value       = aws_iam_role.auditor.arn
}

output "require_tags_policy_arn" {
  description = "ARN de la política que obliga tagging"
  value       = aws_iam_policy.require_tags.arn
}
