variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

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

variable "sns_topic_arn" {
  description = "ARN del SNS topic para notificaciones de presupuesto"
  type        = string
}
