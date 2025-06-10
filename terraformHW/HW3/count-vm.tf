data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

locals {
  ssh_key = file("~/.ssh/id_ed25519.pub")
}

resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = var.default_platform
  zone        = var.default_zone

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh_keys = "ubuntu:${local.ssh_key}"
  }

  depends_on = [yandex_compute_instance.db]

}
