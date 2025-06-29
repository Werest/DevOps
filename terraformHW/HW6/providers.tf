terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.144.0"
    }
  }

  backend "s3" {
    region = "ru-central1"
    bucket = "backet-werest-develop"
    key    = "terraform.state"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    endpoints = {
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g5lq99m43jv5mpei89/etnlegk15et9uh8c8tjm"
      s3       = "https://storage.yandexcloud.net"
    }

    dynamodb_table = "tfstate-werest-develop-2106"
  }
  
  required_version = "~>1.8.4"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  token = var.token
  # service_account_key_file = file("~/.authorized_key.json")
}
