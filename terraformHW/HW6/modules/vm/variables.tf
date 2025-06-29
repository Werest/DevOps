variable "image_family" {
  type = string
  default = "ubuntu-2204-lts"
}

variable "service_account_name" {
  type        = string
  default     = null
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "env_name" {
  type = string
}

variable "platform_id" {
  type = string
}

variable "instance_name" {
  type    = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "preemptible" {
  type = bool
  default = true
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 1
}

variable "core_fraction" {
  type    = number
  default = 20
}

variable "boot_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "boot_disk_size" {
  type    = number
  default = 10
}

variable "subnet_zones" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
}

variable "nat" {
  type = bool
  default = true
}

variable "metadata" {
  type = map(string)
}