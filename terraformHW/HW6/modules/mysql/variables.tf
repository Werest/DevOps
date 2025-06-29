variable "cluster_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "PRESTABLE"
}

variable "network_id" {
  type = string
}

variable "db_preset" {
  type    = string
  default = "s1.micro"
}

variable "disk_type" {
  type    = string
  default = "network-hdd"
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "resource_preset_id" {
  type        = string
  default     = "b1.medium"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "mysql_version" {
  type = string
}