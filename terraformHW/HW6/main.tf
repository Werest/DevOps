#Создайте Virtual Private Cloud (VPC).
#Создайте подсети.
module "vpc" {
  source   = "./modules/vpc"
  env_name = "prod"
  subnets  = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" }, 
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" }
  ]
}

# Security Group
module "app_security" {
  source                 = "./modules/group_security"
  network_id             = module.vpc.vpc_subnet_info[0].network_id
  folder_id              = var.folder_id
  security_group_ingress = var.security_group_ingress_app
  security_group_egress  = var.security_group_egress_app
  security_group_name = "app-security"
}

module "db_security" {
  source = "./modules/group_security"
  security_group_name = "db-security"
  network_id = module.vpc.vpc_subnet_info[0].network_id
  folder_id = var.folder_id
  security_group_ingress = [ 
    {
      protocol = "TCP"
      port = 3306
      description = "Разрешить доступ MySQL приложению"
      security_group_id = module.app_security.security_group_id
    }
   ]
   security_group_egress = var.security_group_egress_db
}

#Mysql
module "mysql" {
  source        = "./modules/mysql"
  cluster_name  = "${var.env_name}-mysql"
  network_id    = module.vpc.vpc_subnet_info[0].network_id
  subnet_id     = module.vpc.vpc_subnet_info[0].id
  mysql_version = "8.0"
  db_user = var.db_user
  db_name = var.db_name
  db_password = var.db_password
  security_group_ids = [module.db_security.security_group_id]
}

#registry
module "container_registry" {
  source    = "./modules/container_registry"
  name      = "app-docker-registry"
  folder_id = var.folder_id
}

# APP
module "app_web" {
  depends_on           = [module.mysql]
  source               = "./modules/vm"
  env_name             = "prod"
  subnet_ids           = [module.vpc.vpc_subnet_info[0].id]
  subnet_zones         = [module.vpc.vpc_subnet_info[0].zone]
  instance_name        = "webs"
  instance_count       = 1
  image_family         = "ubuntu-2204-lts"
  nat                  = true
  platform_id          = "standard-v3"
  core_fraction        = 20
  security_group_ids   = [module.app_security.security_group_id]
  service_account_name = "vm-web-service-account"

  #templatefile(path, vars)
  #templatefile("${path.module}/backends.tftpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
  metadata = {
    user-data = templatefile("${path.module}/cloud-init/cloud-init.tftpl", {
      username = var.username
      db_user = var.db_user
      db_password = var.db_password
      db_name = var.db_name
      mysql_host = module.mysql.mysql_host_fqdn
      ssh_public_key = file("~/.ssh/id_ed25519.pub")
      registry_id = module.container_registry.container_registry_id
      git_clone = var.git_repo
    })
  }
}