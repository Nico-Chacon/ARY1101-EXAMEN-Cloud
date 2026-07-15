variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "common_tags" {
  description = "Tags comunes obligatorios"
  type        = map(string)
  default     = {}
}
