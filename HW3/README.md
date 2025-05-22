## Ремарка
Была проблема с $PWD, подумал, проблема в оболочках. Поэтому с Задачи 4 перешёл на PowerShell. Оказалось нужно указывать в "${PWD}:/data" полностью в ""

# Задача 1
docker build -t custom-nginx:1.0.0 .
docker tag custom-nginx:1.0.0 werest/custom-nginx:1.0.0
docker push werest/custom-nginx:1.0.0

Ссылка - https://hub.docker.com/repository/docker/werest/custom-nginx/tags/1.0.0/sha256-b85b6b635f245db09e94ff57023f2739ebe1c3d199639e8be6aa96411dc501ca

# Задача 2

docker run -d --name chigridovkonstantinalex-custom-nginx-t2 -p 127.0.0.1:8080:80 custom-nginx:1.0.0
docker rename chigridovkonstantinalex-custom-nginx-t2 custom-nginx-t2

date +"%d-%m-%Y %T.%N %Z"; sleep 0.150; docker ps; ss -tlpn | grep 127.0.0.1:8080; docker logs custom-nginx-t2 -n1; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html

curl -v http://127.0.0.1:8080/

# Задача 3
1. docker attach custom-nginx-t2
3. docker ps -a
Контейнер остановился, потому что:
- Nginx работает в foreground-режиме (daemon off)
- Ctrl-C отправил сигнал SIGINT основному процессу (nginx)
- Нет главного процесса - контейнер останавливается

4. docker start custom-nginx-t2
5. docker exec -it custom-nginx-t2 bash
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
apt-get update && apt-get install -y nano
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
nano /etc/nginx/conf.d/default.conf
listen 80; -> listen 81;
8. 
nginx -s reload
curl http://127.0.0.1:80  # Должен вернуть ошибку
curl http://127.0.0.1:81  # Должен показать index.html
exit

10.  Проверьте вывод команд: ss -tlpn | grep 127.0.0.1:8080 , docker port custom-nginx-t2, curl http://127.0.0.1:8080. Кратко объясните суть возникшей проблемы.
ss -tlpn | grep 127.0.0.1:8080  # Покажет проброс порта
docker port custom-nginx-t2      # Покажет 80/tcp → 127.0.0.1:8080
curl http://127.0.0.1:8080      # Не будет работать

Суть проблемы:
Nginx теперь слушает порт 81 внутри контейнера
Но проброс портов (-p) настроен на порт 80 контейнера
Возникло несоответствие между конфигурацией nginx и настройками docker

11. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. пример источника
Не изменяя конфиг nginx, можно перенастроить проброс портов:
docker stop custom-nginx-t2
docker commit custom-nginx-t2 custom-nginx:1.0.1
docker run -d --name custom-nginx-fixed -p 127.0.0.1:8080:81 custom-nginx:1.0.1

(Для изменений в работающем контейнере лучше использовать docker commit)

12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)
docker rm -f custom-nginx-t2
Флаг -f (force) удаляет работающий контейнер без предварительной остановки.

## Terminal:
TASK3-1
TASK3-2
TASK3-3

# Задача 4
1. Запустите первый контейнер из образа centos
docker run -d -v "${PWD}:/data" --name centos_container centos:8 tail -f /dev/null

2. Запустите второй контейнер из образа debian в фоновом режиме
docker run -d -v "${PWD}:/data" --name debian_container debian:latest tail -f /dev/null

3. Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
docker exec centos_container sh -c "echo 'Hello from CentOS' > /data/centos_file.txt"

4. Добавьте ещё один файл в текущий каталог $(pwd) на хостовой машине.

5. Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
docker exec -it debian_container ls -l /data
docker exec -it debian_container cat /data/centos_file.txt
docker exec -it debian_container cat /data/host_file.txt

## Terminal:
Изображание НЕ ГОТОВО! TASK4


# Задача 5
1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

## Ответ
***Docker Compose ищет сначала файлы compose.yaml, compose.yml, docker-compose.yaml, docker-compose.yml / Если в директории есть compose.yaml, он будет выбран автоматически, даже если рядом есть docker-compose.yaml***

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

***Ответ: Docker Compose обнаружил что есть котейнер, который оказался одним, хотя ранее был связан с другим. В данном случае portainer. Он видит, что он был создан из предыдущих манифестов, но в данный момент отсутствует.***

