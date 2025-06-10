# Задание 1
img 1-1 1-2

# Задание 2
### count-vm.tf
```
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
  }

  metadata = {
    ssh_keys = "ubuntu:${local.ssh_key}"
  }

  depends_on = [yandex_compute_instance.db]

}
```

### for_each-vm.tf
```
# variable "each_vm" {
#   type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
# }
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 2
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 4
      disk_volume = 25
    }
  ]
}

resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.key
  platform_id = var.default_platform
  zone        = var.default_zone 

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
}
```

img 2-1

# Задание 3
disk_vm.tf
```
resource "yandex_compute_disk" "vm_disks" {
  count = 3

  name = "disk-${count.index}"
  type = "network-hdd"
  zone = var.default_zone
  size = 1
}

resource "yandex_compute_instance" "storage" {
    name = "storage"
    platform_id = var.default_platform
    zone = var.default_zone

    resources {
      cores = 2
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
      subnet_id = yandex_vpc_subnet.develop.id
      security_group_ids = [yandex_vpc_security_group.example.id]
    }

  metadata = {
    ssh_keys = "ubuntu:${local.ssh_key}"
  }
}
```
img3-1 3-2

# Задание 4
ansible.tf
```
locals {
  # webservers
  webservers = [
    for vm in yandex_compute_instance.web : {
      name      = vm.name
      public_ip = vm.network_interface[0].nat_ip_address
      fqdn      = "${vm.id}.auto.internal"
    }
  ]
  
  # databases
  databases = [
    for key, vm in yandex_compute_instance.db : {
      name      = vm.name
      public_ip = vm.network_interface[0].nat_ip_address
      fqdn      = "${vm.id}.auto.internal"
    }
  ]
  
  #storage
  storage = [
    {
      name      = yandex_compute_instance.storage.name
      public_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn      = "${yandex_compute_instance.storage.id}.auto.internal"
    }
  ]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
  filename = "${path.module}/inventory.ini"
}
```

inventory.tpl
```
[webservers]
%{ for vm in webservers ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}

[databases]
%{ for vm in databases ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}

[storage]
%{ for vm in storage ~}
${vm.name} ansible_host=${vm.public_ip} fqdn=${vm.fqdn}
%{ endfor ~}
```

inventory.ini
```
[webservers]
web-1 ansible_host=158.160.102.102 fqdn=fhmg2j137j4r0qbao68p.auto.internal
web-2 ansible_host=158.160.57.173 fqdn=fhm6bk72vblk8algcb4l.auto.internal

[databases]
main ansible_host=158.160.104.221 fqdn=fhmlvc5j9bfb9hlgdkuf.auto.internal
replica ansible_host=158.160.97.198 fqdn=fhmjt3kvmv8lntntqpp4.auto.internal

[storage]
storage ansible_host=84.201.158.172 fqdn=fhm7qp836rbseeus9240.auto.internal
```




