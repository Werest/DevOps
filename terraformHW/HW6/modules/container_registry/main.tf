# Реестр — хранилище Docker-образов.
# С помощью реестра вы можете разграничивать 
# права доступа к Docker-образам, используя роли Yandex Identity and Access Management.
resource "yandex_container_registry" "default" {
  name      = var.name
  folder_id = var.folder_id
}
