# modules/grafana/variables.tf
# variable "network" {
#   description = "Docker network neve"
#   type        = string
#   default     = "monitoring_network"
# }

variable "prometheus_url" {
  description = "Prometheus URL"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin jelszó"
  type        = string
  default     = "admin"
}