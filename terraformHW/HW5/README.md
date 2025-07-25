### Цели задания

1. Научиться использовать remote state с блокировками.
2. Освоить приёмы командной работы.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Пишем красивый код, хардкод значения не допустимы!

------
### Задание 0
1. Прочтите статью: https://neprivet.com/
2. Пожалуйста, распространите данную идею в своем коллективе.

------

### Задание 1

1. Возьмите код:
- из [ДЗ к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/src),
- из [демо к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1).
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите, какие **типы** ошибок обнаружены в проекте (без дублей).

### Выполнение
2. 
![\Werest\DevOps\terraformHW\HW5\1-1.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/1-1.png)
![\Werest\DevOps\terraformHW\HW5\1-2.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/1-2.png)

3. Есть переменные которые объявлены, но не используются в проекте. Проект не был инициализирован, т.к. не было провайдера. В модулях test-vm и example-vm нет указания конкретной версии на ветке main, есть указание ссылки на ветку, а нужно чтобы ссылались модули на конкретный хеш коммит.
- Идемпотентность - т.е. указав хеш, мы сможем развернуть инфраструктуру даже через год
- Безопасность - исключение риска подмены кода в репозитории

------

### Задание 2

1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.
2. Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте state проекта в S3 с блокировками. Предоставьте скриншоты процесса в качестве ответа.
3. Закоммитьте в ветку 'terraform-05' все изменения.
4. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
5. Пришлите ответ об ошибке доступа к state.
6. Принудительно разблокируйте state. Пришлите команду и вывод.

### Выполнение
!Нужно ещe выдать права на vdb yandex сервисному аккаунту!

```
terraform init -reconfigure
terraform init -reconfigure -lock=false
```
![\Werest\DevOps\terraformHW\HW5\2-1.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-1.png)
![\Werest\DevOps\terraformHW\HW5\2-2.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-2.png)
![\Werest\DevOps\terraformHW\HW5\2-3.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-3.png)
![\Werest\DevOps\terraformHW\HW5\2-4.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-4.png)
![\Werest\DevOps\terraformHW\HW5\2-5.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-5.png)
![\Werest\DevOps\terraformHW\HW5\2-6.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-6.png)
![\Werest\DevOps\terraformHW\HW5\2-7.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/2-7.png)

------
### Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

Ссылка на PR - https://github.com/Werest/DevOpsTerraformHomework4/pull/1


------
### Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console. 

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].

![\Werest\DevOps\terraformHW\HW5\4-1.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/4-1.png)
![\Werest\DevOps\terraformHW\HW5\4-2.png](https://github.com/Werest/DevOps/blob/cd634010f82243b26e73449999023d6bc330a72d/terraformHW/HW5/4-2.png)

Файл - [Файл](variables_hw4.tf)
