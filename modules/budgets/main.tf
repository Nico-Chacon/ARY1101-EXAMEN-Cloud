# ============================================================
# AWS Budgets — Control financiero y alertas de sobrecosto
# EP3 ARY1101 — Automóvil Tech
# ============================================================

# Presupuesto mensual total de la cuenta

resource "aws_budgets_budget" "monthly_total" {
  count = var.enable_budgets ? 1 : 0

  name         = "${var.project_name}-presupuesto-mensual"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  # Alerta al 60% del presupuesto
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 60
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }

  # Alerta al 70% del presupuesto
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 70
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }

  # Alerta al 80% del presupuesto
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }

  # Alerta al 100%
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }

  # Alerta predictiva
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }
}


# ============================================================
# Presupuesto específico EC2
# ============================================================

resource "aws_budgets_budget" "ec2" {
  count = var.enable_budgets ? 1 : 0

  name         = "${var.project_name}-presupuesto-ec2"
  budget_type  = "COST"
  limit_amount = var.ec2_budget_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Elastic Compute Cloud - Compute"]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }
}


# ============================================================
# Presupuesto específico RDS
# ============================================================

resource "aws_budgets_budget" "rds" {
  count = var.enable_budgets ? 1 : 0

  name         = "${var.project_name}-presupuesto-rds"
  budget_type  = "COST"
  limit_amount = var.rds_budget_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Relational Database Service"]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [var.sns_topic_arn]
  }
}