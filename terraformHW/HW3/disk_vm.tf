resource "yandex_compute_disk" "vm_disks" {
  count = 3

  name = "disk-${count.index}"
  type = "network-hdd"
  zone = var.default_zone
  size = 1
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.default_platform
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  dynamic "secondary_disk" {
    for_each = { for idx, disk in yandex_compute_disk.vm_disks : idx => disk.id }
    content {
      disk_id = secondary_disk.value
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
}
