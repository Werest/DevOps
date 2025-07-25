output "vpc_subnet_info" {
  description = "Информация о созданных подсетях"
  value = [
    for subnet in yandex_vpc_subnet.subnet : {
      id          = subnet.id
      zone        = subnet.zone
      cidr_blocks = subnet.v4_cidr_blocks
      network_id  = subnet.network_id
    }
  ]
}