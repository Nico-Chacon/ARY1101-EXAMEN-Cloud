output "budget_monthly_name" {
  value = var.enable_budgets ? aws_budgets_budget.monthly_total[0].name : null
}

output "budget_ec2_name" {
  value = var.enable_budgets ? aws_budgets_budget.ec2[0].name : null
}

output "budget_rds_name" {
  value = var.enable_budgets ? aws_budgets_budget.rds[0].name : null
}