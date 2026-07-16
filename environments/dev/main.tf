# ============================================================
# Automóvil Tech — EFT ARY1101
# Migración, HA, Monitoreo, Costos y Gobierno Cloud en AWS
# ============================================================

# Tags comunes obligatorios — se aplican a TODOS los recursos
locals {
  common_tags = {
    Project     = var.project_name
    Environment = "dev"
    Owner       = var.owner_name
    CostCenter  = "vehiculos"
    ManagedBy   = "terraform"
    CreatedDate = "2026-07"
  }
}

# Obtener el account ID actual (necesario para ECR y CloudTrail)
data "aws_caller_identity" "current" {}

# ----------------------------------------------------------
# MÓDULO: Networking
# ----------------------------------------------------------
module "networking" {
  source       = "../../modules/networking"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

# ----------------------------------------------------------
# MÓDULO: Security Groups
# ----------------------------------------------------------
module "security" {
  source = "../../modules/security"
  vpc_id = module.networking.vpc_id
}

# ----------------------------------------------------------
# MÓDULO: ECR — Repositorios frontend/backend
# ----------------------------------------------------------
module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
}

# ----------------------------------------------------------
# MÓDULO: Base de Datos RDS MySQL Multi-AZ
# ----------------------------------------------------------
module "database" {
  source       = "../../modules/database"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  db_subnets   = module.networking.private_subnets_data
  rds_sg_id    = module.security.rds_sg_id
  db_password  = var.db_password
  db_name      = var.db_name
  db_username  = var.db_username
}

# ----------------------------------------------------------
# MÓDULO: Application Load Balancer
# ----------------------------------------------------------
module "loadbalancer" {
  source         = "../../modules/loadbalancer"
  project_name   = var.project_name
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}

# ----------------------------------------------------------
# MÓDULO: Compute (EC2 ASG + Launch Template) — app real
# ----------------------------------------------------------
module "compute" {
  source           = "../../modules/compute"
  project_name     = var.project_name
  vpc_id           = module.networking.vpc_id
  private_subnets  = module.networking.public_subnets
  target_group_arn = module.loadbalancer.target_group_arn
  ec2_sg_id        = module.security.ec2_sg_id
  ami_id           = var.ami_id
  key_name         = var.key_name
  app_version      = var.app_version

  aws_region            = var.aws_region
  account_id            = data.aws_caller_identity.current.account_id
  db_host               = module.database.db_address
  db_user               = module.database.db_username
  db_password           = var.db_password
  db_name               = module.database.db_name
  db_init_sql_b64       = base64encode(file("${path.module}/../../app/tienda-vehiculos-db/init.sql"))
  ecr_frontend_repo_url = module.ecr.frontend_repo_url
  ecr_backend_repo_url  = module.ecr.backend_repo_url
}

# ----------------------------------------------------------
# MÓDULO: Monitoreo CloudWatch + SNS
# ----------------------------------------------------------
module "monitoring" {
  source         = "../../modules/monitoring"
  project_name   = var.project_name
  asg_name       = module.compute.asg_name
  alb_arn_suffix = module.loadbalancer.alb_arn_suffix
  db_identifier  = module.database.db_identifier
  email_sns      = var.email_sns
  instance_ids   = module.compute.instance_ids
}

# ----------------------------------------------------------
# MÓDULO: AWS Budgets — Control financiero con alertas SNS
# Presupuestos con umbrales 60/70/80/100%
# ----------------------------------------------------------
module "budgets" {
  source             = "../../modules/budgets"
  project_name       = var.project_name
  monthly_budget_usd = var.monthly_budget_usd
  ec2_budget_usd     = var.ec2_budget_usd
  rds_budget_usd     = var.rds_budget_usd
  sns_topic_arn      = module.monitoring.sns_topic_arn
}

# ----------------------------------------------------------
# MÓDULO: CloudTrail — Auditoría y trazabilidad
# ----------------------------------------------------------
module "cloudtrail" {
  source       = "../../modules/cloudtrail"
  project_name = var.project_name
  account_id   = data.aws_caller_identity.current.account_id
  common_tags  = local.common_tags
}

# ----------------------------------------------------------
# MÓDULO: Governance — IAM roles y política de tagging
# DESACTIVADO por defecto: AWS Academy suele BLOQUEAR
# iam:CreateRole/CreatePolicy para el usuario del Lab.
# Prueba a descomentar; si terraform apply falla con
# "AccessDenied" en iam:CreateRole, déjalo comentado y
# documenta el gobierno IAM en el informe solo a nivel de
# LabRole/LabInstanceProfile (que ya trae políticas propias).
# ----------------------------------------------------------
# module "governance" {
#   source       = "../../modules/governance"
#   project_name = var.project_name
#   common_tags  = local.common_tags
# }

# Backup module disabled - AWS Academy no soporta IAM roles para AWS Backup.
# Los respaldos se documentan con snapshots manuales de RDS/EBS (ver guía).
# module "backup" {
#   source           = "../../modules/backup"
#   project_name     = var.project_name
#   ec2_instance_ids = module.compute.instance_ids
#   rds_db_arn       = module.database.db_arn
# }
