variable "env_name" {
  description = "Название сети"
  type        = string
}

variable "subnets" {
  type = list(object({
    zone = string
    cidr = string
  }))
  description = "Зона и CIDR для подсети"
}