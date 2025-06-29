resource "yandex_mdb_mysql_cluster" "mdb_mysql_cluster" {
  name                = var.cluster_name #"<имя_кластера>"
  environment         = var.environment #"<окружение>"
  network_id          = var.network_id #"<идентификатор_сети>"
  version             = var.mysql_version #"<версия_MySQL®>"
  security_group_ids  = var.security_group_ids #[ "<список_идентификаторов_групп_безопасности>" ]

  resources {
    resource_preset_id = var.resource_preset_id #"<класс_хоста>"
    disk_type_id       = var.disk_type #"<тип_диска>"
    disk_size          = var.disk_size #"<размер_хранилища_ГБ>"
  }

  host {
    zone             = var.zone #"<зона_доступности>"
    subnet_id        = var.subnet_id #"<идентификатор_подсети>"
  }
}

resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.mdb_mysql_cluster.id #"<идентификатор_кластера>"
  name       = var.db_name #"<имя_БД>"
}

resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.mdb_mysql_cluster.id #"<идентификатор_кластера>"
  name       = var.db_user #"<имя_пользователя>"
  password   = var.db_password #"<пароль_пользователя>"
  permission {
    database_name = yandex_mdb_mysql_database.db.name #"<имя_БД>"
    roles         = ["ALL"]
  }
}
