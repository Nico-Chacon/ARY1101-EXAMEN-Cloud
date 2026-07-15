# ============================================================
# Governance — Tagging, IAM roles y políticas de control
# EP3 ARY1101 — Automóvil Tech
# ============================================================

# ----------------------------------------------------------
# TAG POLICY: define el estándar de etiquetado de la empresa
# (Se aplica como AWS Organizations Tag Policy si está disponible)
# En AWS Academy se documenta como referencia de governance)
# ----------------------------------------------------------

# Rol IAM de solo lectura para auditores
resource "aws_iam_role" "auditor" {
  name = "${var.project_name}-auditor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name   = "${var.project_name}-auditor-role"
    Role   = "auditor"
    Access = "readonly"
  })
}

# Política de solo lectura para auditores
resource "aws_iam_policy" "auditor_readonly" {
  name        = "${var.project_name}-auditor-readonly"
  description = "Acceso de solo lectura para auditores de AutomovilTech"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "rds:Describe*",
          "s3:GetObject",
          "s3:ListBucket",
          "cloudtrail:GetTrailStatus",
          "cloudtrail:DescribeTrails",
          "cloudtrail:LookupEvents",
          "cloudwatch:GetMetricData",
          "cloudwatch:DescribeAlarms",
          "cost-explorer:GetCostAndUsage",
          "cost-explorer:GetCostForecast",
          "budgets:ViewBudget",
          "iam:Get*",
          "iam:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "auditor_readonly" {
  role       = aws_iam_role.auditor.name
  policy_arn = aws_iam_policy.auditor_readonly.arn
}

# Política que obliga a crear recursos con tags mínimos obligatorios
resource "aws_iam_policy" "require_tags" {
  name        = "${var.project_name}-require-tags-policy"
  description = "Niega creación de recursos EC2/RDS sin los tags obligatorios"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyEC2WithoutRequiredTags"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot"
        ]
        Resource = "*"
        Condition = {
          "Null" = {
            "aws:RequestTag/Project"     = "true"
            "aws:RequestTag/Environment" = "true"
            "aws:RequestTag/Owner"       = "true"
          }
        }
      },
      {
        Sid    = "DenyRDSWithoutRequiredTags"
        Effect = "Deny"
        Action = [
          "rds:CreateDBInstance",
          "rds:CreateDBCluster"
        ]
        Resource = "*"
        Condition = {
          "Null" = {
            "aws:RequestTag/Project"     = "true"
            "aws:RequestTag/Environment" = "true"
          }
        }
      }
    ]
  })
}

# ----------------------------------------------------------
# TAGS OBLIGATORIOS: recurso de referencia (local values)
# Estos tags se aplican a TODOS los módulos vía common_tags
# ----------------------------------------------------------
# Estándar de tagging AutomovilTech:
#   Project     = "automovil-tech"
#   Environment = "dev" | "prod"
#   Owner       = "cloud-team"
#   CostCenter  = "ecommerce"
#   ManagedBy   = "terraform"
#   CreatedDate = "2025-01"
# ----------------------------------------------------------
