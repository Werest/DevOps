variable "ip_addr" {
  description = "ip-адрес"
  type = string
  default = "1920.168.0.1"
  validation {
    condition = can(cidrhost("${var.ip_addr}/32", 0))
    error_message = "Некорректный IP адрес. Пример: 192.168.0.1"
  }
}

variable "ip_addr_list" {
  description="список ip-адресов"
  type=list(string)
  default = ["192.1680.0.1", "1.1.1.1", "127.0.0.1"]
  validation {
    condition = alltrue([
      for ip in var.ip_addr_list : can(cidrhost("${ip}/32", 0))
    ])
    error_message = "Один или несколько адресов некорректны!"
  }
}