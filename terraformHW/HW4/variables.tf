###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "your_ssh_ed25519_key"
  description = "ssh-keygen -t ed25519"
}

###example vm_web var
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
}

variable "ssh_public_key" {
  type        = string
  description = "Location of SSH public key."
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vm_marketing" {
  type = object({
    env_name       = string
    instance_name  = string
    instance_count = number
    public_ip      = bool
    owner          = string
    project        = string
  })
  default = {
    env_name       = "develop"
    instance_name  = "webs"
    instance_count = 1
    public_ip      = true
    owner          = "chigridov_ka"
    project        = "marketing"
  }
}

variable "vm_analytics" {
  type = object({
    env_name       = string
    instance_name  = string
    instance_count = number
    public_ip      = bool
    owner          = string
    project        = string
  })
  default = {
    env_name       = "develop"
    instance_name  = "web-stage"
    instance_count = 1
    public_ip      = true
    owner          = "chigridov_ka"
    project        = "analytics"
  }
}

variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Name OS"
}
