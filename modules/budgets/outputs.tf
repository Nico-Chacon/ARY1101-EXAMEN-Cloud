output "budget_monthly_name" {
  description = "Nombre del presupuesto mensual total"
  value       = aws_budgets_budget.monthly_total.name
}

output "budget_ec2_name" {
  description = "Nombre del presupuesto EC2"
  value       = aws_budgets_budget.ec2.name
}

output "budget_rds_name" {
  description = "Nombre del presupuesto RDS"
  value       = aws_budgets_budget.rds.name
}
