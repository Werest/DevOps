![task](https://github.com/Werest/DevOps/blob/4bcb891fabc45f7aa9e58b4b7c0ad8bb89440ee9/HW4/task1/task0.png)

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
![\Werest\DevOps\HW4\task1\Задача 1.png](https://github.com/Werest/DevOps/blob/4bcb891fabc45f7aa9e58b4b7c0ad8bb89440ee9/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B0%201.png)
#### Пункт 3
![\Werest\DevOps\HW4\task1\Задача 1 - 3.png](https://github.com/Werest/DevOps/blob/4bcb891fabc45f7aa9e58b4b7c0ad8bb89440ee9/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B0%201%20-%203.png)
#### Пункт 4
Добавил в main.py переменную DB_TABLE
```python
app = Flask(__name__)
db_host=os.environ.get('DB_HOST')
db_user=os.environ.get('DB_USER')
db_password=os.environ.get('DB_PASSWORD')
db_database=os.environ.get('DB_NAME')
db_table=os.environ.get('DB_TABLE')

# Подключение к базе данных MySQL
db = mysql.connector.connect(
host=db_host,
user=db_user,
password=db_password,
database=db_database,
autocommit=True )
cursor = db.cursor()

# SQL-запрос для создания таблицы в БД
create_table_query = f"""
CREATE TABLE IF NOT EXISTS {db_database}.{db_table} (
id INT AUTO_INCREMENT PRIMARY KEY,
request_date DATETIME,
request_ip VARCHAR(255)
)
"""
cursor.execute(create_table_query)
```

![\Werest\DevOps\HW4\task1\Задача 1 - 4.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B0%201%20-%204.png)

# Задача 3
Возникала ошибка внутри контейнера haproxy, помогло лишь user: "root", тогда без проблем запустилась данная конфигурация
![\Werest\DevOps\HW4\task1\Задание 3.png](https://github.com/Werest/DevOps/blob/4bcb891fabc45f7aa9e58b4b7c0ad8bb89440ee9/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%203.png)

Выполненые задания
![\Werest\DevOps\HW4\task1\Задание 3 - 1.png](https://github.com/Werest/DevOps/blob/4bcb891fabc45f7aa9e58b4b7c0ad8bb89440ee9/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%203%20-%201.png)

![\Werest\DevOps\HW4\task1\Задание 3 - 2.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%203%20-%202.png)

# Задача 4
![\Werest\DevOps\HW4\task1\Задание 4-1.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%204-1.png)

![\Werest\DevOps\HW4\task1\Задача 4-2.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B0%204-2.png)

# Задача 6
Скачайте docker образ hashicorp/terraform:latest и скопируйте бинарный файл /bin/terraform на свою локальную машину, используя dive и docker save. Предоставьте скриншоты действий .

![\Werest\DevOps\HW4\task1\Задание6-2.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B56-2.png)

![\Werest\DevOps\HW4\task1\Задание6-3.png](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B56-3.png)

# Задача 6.1
Добейтесь аналогичного результата, используя docker cp.
![img](https://github.com/Werest/DevOps/blob/1691932e1532ba6b6c6d9d6e23dd7e486ad7065e/HW4/task1/%D0%97%D0%B0%D0%B4%D0%B0%D0%BD%D0%B8%D0%B56.1-1.png)