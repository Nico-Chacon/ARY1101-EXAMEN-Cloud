variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "account_id" {
  description = "ID de la cuenta AWS (para nombrar el bucket único)"
  type        = string
}

variable "common_tags" {
  description = "Tags comunes aplicados a todos los recursos"
  type        = map(string)
  default     = {}
}
