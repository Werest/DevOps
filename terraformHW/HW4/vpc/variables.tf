variable "vpc_name" {
  type = string
  default = "vpc-network"
}

# Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
variable "zone" {
  type = string
  default = "ru-central1-a"
}
variable "v4_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}