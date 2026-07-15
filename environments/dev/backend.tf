terraform {
  backend "s3" {
    bucket         = "automoviltech-tfstate-CAMBIAR"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "automoviltech-tflocks-CAMBIAR"
    encrypt        = true
  }
}
