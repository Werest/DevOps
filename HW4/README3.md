# Задача 1
запустить mysql для приложения
docker run -dit -p 3306:3306 -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" --name db mysql

```
cd ~
python3 -m venv myenv
source myenv/bin/activate
cd /media/sf_Devops/DevOps/HW4/shvirtd-example-python
pip install -r requirements.txt
```
db_table = requests

### Выполнение
[img] (Задача 1)
#### Пункт 3
[img] (Задача 1-3)
#### Пункт 4
[img] (Задача 1-4)

# Задача 3
Возникала ошибка внутри контейнера haproxy, помогло лишь user: "root", тогда без проблем запустилась данная конфигурация
Скрин с ошибкой

Выполненые задания

# Задача 4

# Задача 6

# Задача 6.1