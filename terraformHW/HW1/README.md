# Домашнее задание к занятию «Введение в Terraform»

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии >=1.8.4 . Приложите скриншот вывода команды ```terraform --version```.
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )

### Выполнение
PowerShell $env:TF_CLI_CONFIG_FILE="F:/Devops/terraform_1.12.1_windows_amd64/.terraformrc"
Ubuntu export TF_CLI_CONFIG_FILE=""

1. IMG Terraform --version 
![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/2025-06-01%2011%2046%2038.png)
2. Секретную информацию можно сохранить в файле personal.auto.tfvars
3. "result": "4tjDPTID2JZC7ri5"
![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/2025-06-01%2012%2030%2041.png)
4-5. 
![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/2025-06-01%2012%2030%2041.png)
- У ресурса docker_image отсутствует имя
- В ресурсе docker_container некорректное обращение к random_password
- Имя контейнера 1nginx недопустимо (не может начинаться с цифры).
```
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
}
```

6.
![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/4-2.png)
```
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello_world"

  ports {
    internal = 80
    external = 9090
  }
}
```
Опасность -auto-approve:
Ключ -auto-approve пропускает интерактивное подтверждение изменений, что может привести к неожиданному изменению или удалению ресурсов без проверки. Например, случайный запуск terraform destroy -auto-approve уничтожит всю инфраструктуру без запроса.
Для чего подойдет:
В CI/CD-пайплайнах для автоматического применения изменений.
Для скриптов, где нет интерактивного ввода.

7.
terraform.tfstate
```
{
  "version": 4,
  "terraform_version": "1.12.1",
  "serial": 14,
  "lineage": "0b772a4b-839c-9f43-de23-2b068a591d5c",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
8. В коде явно указано keep_locally = true для ресурса docker_image. Образ не удаляется при уничтожении ресурсов.
Keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the local docker on destroy operation.
------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
2. Подключитесь к ВМ по ssh и установите стек docker.
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.

### Выполнение
Конфиг main.tf
```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
	  random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  required_version = ">=1.8.4"
}

provider "docker" {
  host = "ssh://ubuntu@${var.vm_public_ip}:22"
}

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_root" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_user" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello_world"

  ports {
    internal = 80
    external = 9090
  }
}

# MySQL
resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = false
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql_server"

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_user.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}

output "mysql_credentials" {
  sensitive = true
  value = {
    root_password = random_password.mysql_root.result
    user_password = random_password.mysql_user.result
    database      = "wordpress"
    user          = "wordpress"
  }
}
```
![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%202.png)

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.
------
### Выполнение
```
Could not resolve provider hashicorp/random: could not connect to registry.opentofu.org: failed to request discovery
```
Нужно добавить     include = ["registry.terraform.io/*/*", "registry.opentofu.org/*/*"]

![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/tofu-3.png)

![img](https://github.com/Werest/DevOps/blob/a5d3858afbd9e4966e83140a5841b3e908a2d90f/terraformHW/HW1/tofu-3-1.p)
