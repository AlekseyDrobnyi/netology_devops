1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.
chdir("/tmp")                           = 0

2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
vagrant@vagrant:~$ exec 5>log.txt
vagrant@vagrant:~$ ping localhost >&5

vagrant@vagrant:~$ ps aux
vagrant     1448  0.0  0.1   7172  2732 pts/0    S+   02:51   0:00 ping localhost
vagrant@vagrant:~$ rm log.txt
vagrant@vagrant:~$ sudo lsof -p 1448 | grep log
ping    1448 vagrant    5w   REG  253,0    44245 1048609 /home/vagrant/log.txt (deleted)
vagrant@vagrant:~$ echo "" | sudo tee /proc/1448/fd/5

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

5. В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.
vagrant@vagrant:~$ sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
vagrant@vagrant:~$ dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
установил утилиту, потом запустил

vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
823    vminfo              6   0 /var/run/utmp
636    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
636    dbus-daemon        20   0 /usr/share/dbus-1/system-services
636    dbus-daemon        -1   2 /lib/dbus-1/system-services
636    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
641    irqbalance          6   0 /proc/interrupts
641    irqbalance          6   0 /proc/stat
641    irqbalance          6   0 /proc/irq/20/smp_affinity
641    irqbalance          6   0 /proc/irq/0/smp_affinity

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
системный вызов uname()

7. Чем отличается последовательность команд через ; и через && в bash? Например:
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
Есть ли смысл использовать в bash &&, если применить set -e?
Оператор точка с запятой позволяет запускать несколько команд за один раз, и выполнение команды происходит последовательно.
Оператор AND (&&) будет выполнять вторую команду только в том случае, если при выполнении первой команды SUCCEEDS, т.е. состояние выхода первой команды равно «0» — программа выполнена успешно. Эта команда очень полезна при проверке состояния выполнения последней команды.
Использовать && и set -e, нет смысла, как понял, будет двойная проверка на «0»
set -e - Exit immediately if a command exits with a non-zero status.

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
-e  Exit immediately if a command exits with a non-zero status. (выход, если команда завершается с ненулевым статусом.)
-u  Treat unset variables as an error when substituting. (определяет неустановленные переменные как ошибку)
-x  Print commands and their arguments as they are executed.(печатать команды и их аргументы по мере их выполнения.)
- o pipefail  the return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero 
такая опция, вероятно, помогает в сценарии, потому что он будет прекращаться при первой же ошибке, кроме последней (o pipefail)

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
часто встречающиеся это S(Ss,S,Ssl) и I(I<,I)
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display
       to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
               
STAT
Ss
S
I<
I<
I<
I<
S
I
S
S
S
S
S
S
S
I<
S
I<
S
S
S
S
I<
S
SN
SN
I<
I<
I<
I<
I<
I<
I<
I<
S
S
S
I<
I<
S
I<
S
I<
I<
I<
I<
I<
I<
S
I<
I<
I<
I<
I<
I<
I<
S
I<
S<s
Ss
I<
I<
I<
I<
I<
SLsl
S<
S<
S<
S<
S<
S
I<
S<
Ss
Ss
Ssl
Ss
Ssl
Ss
Ssl
Ssl
Ss
Ssl
Ss
Ss+
Ss
Ss
Ssl
Sl
Ss
S
S
R
I
I
Ss
S
Ss+
I
I
I
I
I
Ss
S
Ss
I
R+


