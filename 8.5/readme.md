# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
```bash
[centos@localhost ~]$ molecule --version
molecule 3.5.2 using python 3.6 
    ansible:2.9.27
    delegated:3.5.2 from molecule
    ```
3. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos8` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
```bash
[centos@localhost vector-role]$ molecule init scenario os --driver-name openstack
INFO     Initializing new scenario os...
INFO     Initialized scenario in /home/centos/.ansible/roles/vector-role/molecule/os successfully.
[centos@localhost vector-role]$ molecule init scenario doc --driver-name docker
INFO     Initializing new scenario doc...
INFO     Initialized scenario in /home/centos/.ansible/roles/vector-role/molecule/doc successfully.
[centos@localhost vector-role]$ molecule init scenario ubuntu_latest --driver-name docker
INFO     Initializing new scenario ubuntu_latest...
INFO     Initialized scenario in /home/centos/.ansible/roles/vector-role/molecule/ubuntu_latest successfully.

```
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
```bash
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
  - name: Example assertion
    assert:
      that: true
  - name: Check NGINX configs
    shell: vector validate --no-environment --config-yaml /etc/vector/vector.yml
  - name: Check NGINX status
    shell: ps aux | grep [v]ector
```
```bash
[centos@localhost vector-role]$molecule test -s centos7
INFO     centos7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/centos/.ansible/roles/vector-role/ as project root directory
INFO     Using /home/centos/.ansible/roles/vector-role/ symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/centos/.cache/ansible-lint/d5239f/roles
INFO     Running centos7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos7 > lint
INFO     Lint is disabled.
INFO     Running centos7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running centos7 > syntax

playbook: /home/centos/.ansible/roles/vector-role/molecule/centos7/converge.yml
INFO     Running centos7 > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'centos7', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'centos7', 'name': 'instance', 'pre_build_image': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'centos7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/centos7) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'centos7', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '498803258345.165895', 'results_file': '/home/panmonster/.ansible_async/498803258345.165895', 'changed': True, 'item': {'image': 'centos7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running centos7 > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos7 > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include roles_vector] ****************************************************

TASK [roles_vector : Install vector] *******************************************
skipping: [instance]

TASK [roles_vector : Install vector] *******************************************
included: /home/centos/.ansible/roles/vector-role/tasks/install_vector_docker.yml for instance

TASK [roles_vector : VECTOR | Install rpm] *************************************
changed: [instance]

TASK [roles_vector : VECTOR | Template config] *********************************
changed: [instance]

TASK [roles_vector : Put docker package on hold] *******************************
ok: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running centos7 > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include roles_vector] ****************************************************

TASK [roles_vector : Install vector] *******************************************
skipping: [instance]

TASK [roles_vector : Install vector] *******************************************
included: /home/centos/.ansible/roles/vector-role/tasks/install_vector_docker.yml for instance

TASK [roles_vector : VECTOR | Install rpm] *************************************
ok: [instance]

TASK [roles_vector : VECTOR | Template config] *********************************
ok: [instance]

TASK [roles_vector : Put docker package on hold] *******************************
ok: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running centos7 > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos7 > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Check NGINX configs] *****************************************************
changed: [instance]

TASK [Check NGINX status] ******************************************************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running centos7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos7 > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
[0.2.0](https://github.com/AlekseyDrobnyi/vector/tree/0.2.0)
### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
```
[centos@localhost ~]$ sudo tox -r
py38-ansible210 recreate: /home/centos/.ansible/roles/vector-role/.tox/py38-ansible210
py38-ansible210 installdeps: -rtox-requirements.txt, ansible<2.12
py38-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.0.4,ansible-lint==5.1.3,arrow==1.2.2,bcrypt==3.2.2,binaryornot==0.4.4,bracex==2.2.1,Cerberus==1.3.2,certifi==2021.10.8,cffi==1.15.0,chardet==4.0.0,charset-


...............


TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
_________________________________________________________________________________________________ summary _________________________________________________________________________________________________
  py38-ansible210: commands succeeded
  py38-ansible30: commands succeeded
  congratulations :)
  ```
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
```bash
[centos@localhost ~]$ molecule matrix test
INFO     Test matrix
---                                                                             
centos7:                                                                        
  - dependency                                                                  
  - lint                                                                        
  - cleanup                                                                     
  - destroy                                                                     
  - syntax                                                                      
  - create                                                                      
  - prepare                                                                     
  - converge                                                                    
  - idempotence                                                                 
  - side_effect                                                                 
  - verify                                                                      
  - cleanup                                                                     
  - destroy                                                                     
centos7_Lite:                                                                   
  - create                                                                      
  - prepare                                                                     
  - converge                                                                    
  - idempotence                                                                 
  - side_effect                                                                 
  - verify                                                                      
  - cleanup                                                                     
  - destroy 
  ```
5. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
```bash
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{38}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
  -r tox-requirements.txt
  ansible210: ansible<2.12
  ansible30: ansible<3.1
commands =
  {posargs:molecule test -s centos7_lite --destroy always}
  ```
6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
[0.3.0](https://github.com/AlekseyDrobnyi/vector/tree/main)
