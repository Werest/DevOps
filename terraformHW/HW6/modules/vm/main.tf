data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

# Создать сервисный аккаунт
# имя сервисного аккаунта. Обязательный параметр
data "yandex_iam_service_account" "service_account" {
  name = var.service_account_name
}

resource "yandex_compute_instance" "vm" {
  count = var.instance_count

  name               = "${var.env_name}-${var.instance_name}-${count.index}"
  platform_id        = var.platform_id
  hostname           = "${var.env_name}-${var.instance_name}-${count.index}"
  zone               = var.default_zone
  service_account_id = data.yandex_iam_service_account.service_account.id

  scheduling_policy {
    preemptible = var.preemptible
  }

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.boot_disk_size
      type     = var.boot_disk_type
    }
  }

  #retrieves a single element from a list.
  #element(list, index)
  network_interface {
    subnet_id          = element(var.subnet_ids, count.index)
    security_group_ids = var.security_group_ids
    nat                = var.nat
  }

  metadata = {
    for i, j in var.metadata : i => j
  }
}
