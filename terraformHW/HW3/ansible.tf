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