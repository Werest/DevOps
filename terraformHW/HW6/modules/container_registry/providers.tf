terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.144.0"
    }
  }

  required_version = ">=1.8.4"
}