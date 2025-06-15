# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }
# resource "yandex_vpc_subnet" "develop" {
#   name           = var.vpc_name
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }

module "vpc" {
  source         = "./vpc"
  zone           = var.default_zone
  v4_cidr_blocks = var.default_cidr
}

module "marketing-vm" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name = var.vm_marketing.env_name
  # network_id     = yandex_vpc_network.develop.id
  network_id   = module.vpc.vpc_network.id
  subnet_zones = [var.default_zone]
  # subnet_ids     = [yandex_vpc_subnet.develop.id]
  subnet_ids     = [module.vpc.vpc_subnet.id]
  instance_name  = var.vm_marketing.instance_name
  instance_count = var.vm_marketing.instance_count
  image_family   = var.vm_family
  public_ip      = var.vm_marketing.public_ip

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

  labels = {
    owner   = var.vm_marketing.owner
    project = var.vm_marketing.project
  }
}

module "analytics-vm" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name = var.vm_analytics.env_name
  # network_id     = yandex_vpc_network.develop.id
  network_id     = module.vpc.vpc_network.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [module.vpc.vpc_subnet.id]
  instance_name  = var.vm_analytics.instance_name
  instance_count = var.vm_analytics.instance_count
  image_family   = var.vm_family
  public_ip      = var.vm_analytics.public_ip

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

  labels = {
    owner   = var.vm_analytics.owner
    project = var.vm_analytics.project
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    "ssh_public_key" = file(var.ssh_public_key)
  }
}
