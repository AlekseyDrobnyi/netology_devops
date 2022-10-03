# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

ссылка на мой подготовленный [playbook](https://github.com/AlekseyDrobnyi/netology_devops/tree/main/8.2/playbook)  


## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
после первых попыток запуска ```play``` получал ошибку, как понял, что не получалось создать БД. Не хватало прав.
```bash
[centos@clickhouse-01 ~]$ service clickhouse-server status
std::exception. Code: 1001, type: std::__1::__fs::filesystem::filesystem_error, e.what() = filesystem error: in posix_stat: failed to determine attributes for the specified path: Permission denied [/var/run/clickhouse-server/clickhouse-server.pid]
Cannot print extra info for Poco::Exception (version 22.3.3.44 (official build))
[centos@clickhouse-01 ~]$ chmod 755 /etc/clickhouse-server
chmod: изменение прав доступа для «/etc/clickhouse-server»: Операция не позволена
[centos@clickhouse-01 ~]$ sudo chmod 755 /etc/clickhouse-server
```
После этого  ```playbook``` полностью был выполнен.
```bash
[centos@localhost playbook]$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Clickhouse] **************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 500: Internal Server Error", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 500, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************
ok: [clickhouse-01]

TASK [Create database] *****************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] ******************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [vector-01]

TASK [Download Vector] *****************************************************************************************
changed: [vector-01]

TASK [Install Vector] ******************************************************************************************
changed: [vector-01]

PLAY RECAP *****************************************************************************************************
clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
ошибок не найдено.
```bash
[centos@localhost playbook]$ ansible-lint site.yml
[centos@localhost playbook]$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```

[centos@localhost playbook]$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] **************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 500: Internal Server Error", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 500, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************
ok: [clickhouse-01]

TASK [Create database] *****************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ******************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [vector-01]

TASK [Download Vector] *****************************************************************************************
ok: [vector-01]

TASK [Install Vector] ******************************************************************************************
ok: [vector-01]

PLAY RECAP *****************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```bash
[centos@localhost playbook]$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] **************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 500: Internal Server Error", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 500, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **********************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************
ok: [clickhouse-01]

TASK [Create database] *****************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] ******************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [vector-01]

TASK [Download Vector] *****************************************************************************************
ok: [vector-01]

TASK [Install Vector] ******************************************************************************************
ok: [vector-01]

PLAY RECAP *****************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
