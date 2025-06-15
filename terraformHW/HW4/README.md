### Задание 1

main.tf
```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

module "marketing-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.vm_marketing.env_name
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.develop.id]
  instance_name  = var.vm_marketing.instance_name
  instance_count = var.vm_marketing.instance_count
  image_family   = var.vm_family
  public_ip      = var.vm_marketing.public_ip

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

  labels = {
    owner = var.vm_marketing.owner
    project = var.vm_marketing.project
  }
}

module "analytics-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.vm_analytics.env_name
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.default_zone]
  subnet_ids     = [yandex_vpc_subnet.develop.id]
  instance_name  = var.vm_analytics.instance_name
  instance_count = var.vm_analytics.instance_count
  image_family   = var.vm_family
  public_ip      = var.vm_analytics.public_ip

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

  labels = {
    owner = var.vm_analytics.owner
    project = var.vm_analytics.project
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    "ssh_public_key" = file(var.ssh_public_key)
  }
}
```

cloud-init.yml
```
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys: 
      - ${ssh_public_key}
package_update: true
package_upgrade: false
packages:
  - vim
  - nginx  
```

![\Werest\DevOps\terraformHW\HW4\1-1.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/1-1.png)
![\Werest\DevOps\terraformHW\HW4\1-2.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/1-2.png)
![\Werest\DevOps\terraformHW\HW4\1-3.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/1-3.png)
![\Werest\DevOps\terraformHW\HW4\1-4.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/1-4.png)
![\Werest\DevOps\terraformHW\HW4\1-5.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/1-5.png)

-------------------------------------------
### Задание 2

## VPC
## variables.tf
```
variable "vpc_name" {
  type = string
  default = "vpc-network"
}

# Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
variable "zone" {
  type = string
  default = "ru-central1-a"
}
variable "v4_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
```

## main.tf
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = "${var.vpc_name}-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.v4_cidr_blocks
}
```

## root main.tf
```
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
```

Сгенерируйте документацию к модулю с помощью terraform-docs
```
docker run --rm -v ${PWD}:/data -w /data quay.io/terraform-docs/terraform-docs:0.20.0 markdown table --output-file README.md .
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_v4_cidr_blocks"></a> [v4\_cidr\_blocks](#input\_v4\_cidr\_blocks) | n/a | `list(string)` | <pre>[<br/>  "10.0.1.0/24"<br/>]</pre> | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `"vpc-network"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Вы должны передать в модуль переменные с названием сети, zone и v4\_cidr\_blocks. | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_network"></a> [vpc\_network](#output\_vpc\_network) | network VPC |
| <a name="output_vpc_subnet"></a> [vpc\_subnet](#output\_vpc\_subnet) | subnet VPC |
<!-- END_TF_DOCS -->

![\Werest\DevOps\terraformHW\HW4\2-1.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/2-1.png)

-------------------------------------------
### Задание 3

Переименование
terraform state mv <old_name> <new_name>

```
terraform state list
terraform state rm 
terraform import module.analytics-vm.yandex_compute_instance.vm[0] id
```
![\Werest\DevOps\terraformHW\HW4\3-1.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/3-1.png)
![\Werest\DevOps\terraformHW\HW4\3-2.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/3-2.png)
![\Werest\DevOps\terraformHW\HW4\3-3.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/3-3.png)
![\Werest\DevOps\terraformHW\HW4\3-4.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/3-4.png)
![\Werest\DevOps\terraformHW\HW4\3-5.png](https://github.com/Werest/DevOps/blob/e378ce867d411ad6365e390a3bce1c1d8eb2d13f/terraformHW/HW4/3-5.png)
