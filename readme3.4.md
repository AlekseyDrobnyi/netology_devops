1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. 
Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

поместите его в автозагрузку,
предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

файл создал:

vagrant@vagrant:~$ sudo cat /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
Documentation=https://github.com/prometheus/node_exporter
[Service]
ExecStart=/usr/local/bin/node_exporter
EnvironmentFile=/etc/default/node_exporter
[Install]
WantedBy=multi-user.target

vagrant@vagrant:~$ sudo cat /etc/default/node_exporter
OPTIONS=""

проверил запуск/перезапуск/рестарт:

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


2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:
![image](https://user-images.githubusercontent.com/99823951/161235048-f8be5646-ba98-4538-b696-43cbc2db9c49.png)


в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
vagrant@vagrant:~$ dmesg | grep virtu
[    0.001102] CPU MTRRs all blank - virtualized system.
[    0.082072] Booting paravirtualized kernel on KVM
[    0.248885] Performance Events: PMU not available due to virtualization, using software events only.
[    2.830251] systemd[1]: Detected virtualization oracle.

очень похоже, что осознает, т.к. упоминается виртуализация Оракл

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

По умолчанию fs.nr_open настроен на число 1048576. Это максимальное количество открытых десткрипторов для пользователя.

vagrant@vagrant:~$ cat /proc/sys/fs/nr_open
1048576

vagrant@vagrant:~$ ulimit -Hn
1048576
 - это жесткий лимит на пользователя, его нельзя увеличивать, только уменьшать
 - есть еще -Sn. это мягкий лимит на пользователя. По умолчанию стоял 1024. Его можно увеливать.
Но оба - не больше fs.nr_open

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

root@vagrant:~# ps aux | grep sleep
root        2072  0.0  0.0   5476   596 pts/1    S+   10:31   0:00 sleep 1h
root@vagrant:~# nsenter --target 2072 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
     11 pts/2    00:00:00 bash
     23 pts/2    00:00:00 ps


7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Это так называемая "The fork bomb" состоит из фукнции, которая выполняется рекурсивно.
и как правило, чтобы решить проблему использую ulimit для ограничения.
vagrant@vagrant:~$ ulimit -u 50

dmesg же показал вот это - 
[ 4912.560957] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope
