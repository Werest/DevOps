output "container_registry_id" {
  description = "ID container_registry"
  value       = yandex_container_registry.default.id
}

output "container_registry_name" {
  description = "Имя container_registry"
  value       = yandex_container_registry.default.name
}
