output "vpc_network" {
  value       = yandex_vpc_network.develop
  description = "network VPC"
}

output "vpc_subnet" {
  value       = yandex_vpc_subnet.develop
  description = "subnet VPC"
}
