# modules/prometheus/variables.tf


variable "app_port" {
  description = "NodeJS alkalmazás portja"
  type        = number
  default     = 3000
}