# Домашнее задание к занятию "Операционные системы. Лекция 2"

### Цель задания

В результате выполнения этого задания вы:
1. Познакомитесь со средством сбора метрик node_exporter и средством сбора и визуализации метрик NetData. Такого рода инструменты позволяют выстроить систему мониторинга сервисов для своевременного выявления проблем в их работе.
2. Построите простой systemd unit файл для создания долгоживущих процессов, которые стартуют вместе со стартом системы автоматически.
3. Проанализируете dmesg, а именно часть лога старта виртуальной машины, чтобы понять, какая полезная информация может там находиться.
4. Поработаете с unshare и nsenter для понимания, как создать отдельный namespace для процесса (частичная контейнеризация).
------

## Задание

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

файл создал:
```bash 
vagrant@vagrant:~$ sudo cat /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
[Service]
ExecStart=/usr/local/bin/node_exporter  $OPTIONS
EnvironmentFile=/etc/default/node_exporter
[Install]
WantedBy=multi-user.target

vagrant@vagrant:~$ sudo cat /etc/default/node_exporter
OPTIONS=""
```  
проверил запуск/перезапуск/рестарт:
```bash 
vagrant@vagrant:~$ ps -e | grep node
   1969 ?        00:00:00 node_exporter
vagrant@vagrant:~$ systemctl stop node_exporter
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to stop 'node_exporter.service'.
Authenticating as: vagrant
Password:
==== AUTHENTICATION COMPLETE ===
vagrant@vagrant:~$ ps -e | grep node
vagrant@vagrant:~$ systemctl start node_exporter
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'node_exporter.service'.
Authenticating as: vagrant
Password:
==== AUTHENTICATION COMPLETE ===
vagrant@vagrant:~$ ps -e | grep node
   2107 ?        00:00:00 node_exporter
vagrant@vagrant:~$ systemctl restart node_exporter
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
```

Предлагаю уточнить как именно в службу будут передаваться дополнительные опции. 

в разделе [Service] я в файле readme не указал переменную, на которую ссылаться будет служба при запуске. 
`ExecStart=/usr/local/bin/node_exporter  $OPTIONS`
`EnvironmentFile=/etc/default/node_exporter` - а тут разместил сам файл с опциями.
```bash 
vagrant@vagrant:~$ sudo cat /etc/default/node_exporter
OPTIONS = --collector.cpu.guest --collector.cpu.info
```
```bash 
vagrant@vagrant:~$ systemctl status node_exporter.service
● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-04-05 12:47:38 UTC; 2min 39s ago
       Docs: https://github.com/prometheus/node_exporter
   Main PID: 2190 (node_exporter)
      Tasks: 4 (limit: 2279)
     Memory: 2.3M
     CGroup: /system.slice/node_exporter.service
             └─2190 /usr/local/bin/node_exporter --collector.cpu.guest --collector.cpu.info
```


2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

запустил и ознакомился с метриками - curl http://localhost:9100/metrics

для CPU: 
```
node_cpu_seconds_total{cpu="0",mode="system"} 9.66
node_cpu_seconds_total{cpu="0",mode="user"} 5.75
node_cpu_seconds_total{cpu="1",mode="idle"} 1555.77
```
memory:
```
node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
node_memory_MemFree_bytes Memory information field MemFree_bytes.
```
disk:
```
node_disk_write_time_seconds_total This is the total number of seconds spent by all writes.
node_disk_read_time_seconds_total The total number of seconds spent by all reads.
node_disk_read_bytes_total The total number of bytes read successfully.
node_disk_io_time_seconds_total Total seconds spent doing I/Os.
```
network:
```
node_network_transmit_errs_total Network device statistic transmit_errs.
node_network_transmit_bytes_total Network device statistic transmit_bytes.
node_network_receive_errs_total Network device statistic receive_errs.
node_network_receive_bytes_total Network device statistic receive_bytes.
```

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`).  

![image](https://user-images.githubusercontent.com/99823951/161235048-f8be5646-ba98-4538-b696-43cbc2db9c49.png)


   После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:  
`config.vm.network "forwarded_port", guest: 19999, host: 19999`  

После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
```bash
vagrant@vagrant:~$ dmesg | grep virtu
[    0.001102] CPU MTRRs all blank - virtualized system.
[    0.082072] Booting paravirtualized kernel on KVM
[    0.248885] Performance Events: PMU not available due to virtualization, using software events only.
[    2.830251] systemd[1]: Detected virtualization oracle.
```  
очень похоже, что осознает, т.к. упоминается виртуализация Оракл  

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?  

По умолчанию fs.nr_open настроен на число 1048576. Это максимальное количество открытых десткрипторов для пользователя.  
```bash
vagrant@vagrant:~$ cat /proc/sys/fs/nr_open
1048576

vagrant@vagrant:~$ ulimit -Hn
1048576
```
 - это жесткий лимит на пользователя, его нельзя увеличивать, только уменьшать  
 - есть еще -Sn. это мягкий лимит на пользователя. По умолчанию стоял 1024. Его можно увеливать.  
Но оба - не больше `fs.nr_open`  

6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

```bash
root@vagrant:~# ps aux | grep sleep
root        2072  0.0  0.0   5476   596 pts/1    S+   10:31   0:00 sleep 1h
root@vagrant:~# nsenter --target 2072 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
     11 pts/2    00:00:00 bash
     23 pts/2    00:00:00 ps
```

7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?


Это так называемая "The fork bomb" состоит из фукнции, которая выполняется рекурсивно.  
и как правило, чтобы решить проблему использую ulimit для ограничения.  
```vagrant@vagrant:~$ ulimit -u 50```

`dmesg` же показал вот это - 
[ 4912.560957] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope
