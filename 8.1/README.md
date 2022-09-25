# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой [репозиторий](https://github.com/AlekseyDrobnyi/netology_devops/tree/main/8.1).

ссылка на [readme.md самоконтроля](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/8.1/playbook/readme.md)

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ cat group_vars/all/examp.yml
---
  some_fact: all default fact
  
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/test.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.  
использовал ```local```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact'"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
``` bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] *******************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact'"
}

PLAY RECAP ************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
ansible-doc -t connection -l
подойдет плагин ```local```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: local
  deb:
    hosts:
      ubuntu:
        ansible_connection: local
  local:
    hosts:
      localhost:
        ansible_connection: local
```        
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ********************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact'"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password: 
Decryption successful
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-vault decrypt group_vars/el/examp.yml
Vault password: 
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```bash
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input)
PaSSw0rd!vault |
          $ANSIBLE_VAULT;1.1;AES256
          63393633343065346232643461663934636462643961333235346662356239663938633236303536
          6331333034323761326462613634626365376563383036320a643165306539343238383838653530
          34373065646561646561303938376538376339356137653963643438643932373932636637326438
          6131306362393530350a613132353735346466623731653364363237363230643866353763363733
          6234
Encryption successful
ubuntu@ubuntu-VirtualBox:~/git/netology_devops/8.1/playbook$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ********************************************************************************************************************
ok: [centos7] => {
    "msg": "Ubuntu"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact'"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

