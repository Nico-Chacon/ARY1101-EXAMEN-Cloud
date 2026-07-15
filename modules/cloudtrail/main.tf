# ============================================================
# CloudTrail — Registro de auditoría de eventos AWS
# EP3 ARY1101 — Automóvil Tech
# ============================================================

# Bucket S3 donde CloudTrail guarda los logs
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.project_name}-cloudtrail-logs-${var.account_id}"
  force_destroy = true

  tags = merge(var.common_tags, {
    Name    = "${var.project_name}-cloudtrail-logs"
    Purpose = "audit-logging"
  })
}

# Bloquear acceso público al bucket de logs
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket                  = aws_s3_bucket.cloudtrail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Política del bucket: solo CloudTrail puede escribir
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${var.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.cloudtrail]
}

# Trail principal — registra eventos de gestión en todas las regiones
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  # Registrar eventos de gestión (crear/eliminar/modificar recursos)
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    # Registrar también accesos a S3 (eventos de datos)
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = merge(var.common_tags, {
    Name    = "${var.project_name}-trail"
    Purpose = "governance-audit"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

# Alarma CloudWatch: detecta si alguien desactiva CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.project_name}"
  retention_in_days = 90

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-cloudtrail-logs"
  })
}
