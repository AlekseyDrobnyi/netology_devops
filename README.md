1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
cd is a shell builtin
это встроенная команда. Встроенная, наверно потому что используется для смены директории в текущей сессии при подключении к консоли. 


2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.
vagrant@vagrant:~$ cat www.txt
qqqqqq
wwwwww
22222
123
322

vagrant@vagrant:~$ grep 2 www.txt | wc -l
3
vagrant@vagrant:~$ grep 22222 www.txt | wc -l
1
vagrant@vagrant:~$ grep 2 www.txt -c
3
vagrant@vagrant:~$ grep 22222 www.txt -c
1



3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
vagrant@vagrant:~$ pstree -p
systemd(1)─┬─VBoxService(838)─┬─{VBoxService}(839)
           │                  ├─{VBoxService}(840)


4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
vagrant@vagrant:~$ who
vagrant  pts/0        2022-03-27 02:22 (10.0.2.2)
vagrant  pts/1        2022-03-27 03:38 (10.0.2.2)
vagrant@vagrant:~$ ls -l \root 2>/dev/pts/1

во втором терминале получил
vagrant@vagrant:~$ ls: cannot access 'root': No such file or directory


5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
vagrant@vagrant:~$ cat www.txt
qqqqqq
wwwwww
22222
123
322

vagrant@vagrant:~$ cat newWWW.txt
cat: newWWW.txt: No such file or directory
vagrant@vagrant:~$ cat < www.txt > newWWW.txt
vagrant@vagrant:~$ cat newWWW.txt
qqqqqq
wwwwww
22222
123
322

vagrant@vagrant:~$


6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
vagrant@vagrant:~$ who
vagrant  pts/0        2022-03-27 02:22 (10.0.2.2)
vagrant  pts/1        2022-03-27 04:11 (10.0.2.2)
vagrant  tty2         2022-03-27 04:28
vagrant@vagrant:~$ echo hello! Hola! >/dev/tty2
vagrant@vagrant:~$ tty
/dev/pts/0
Данные получилось наблюдать, когда открыл в VirtualBox ВМ. На TTY получилось отправить данные.

7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
bash 5>&1 - создаст новый дескриптор и направить поток в stdout

vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
netology
vagrant@vagrant:~$
Произойдет вывод в дескриптор 5


8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
vagrant@vagrant:~$ cat zxc.txt
cat: zxc.txt: No such file or directory
vagrant@vagrant:~$ cat zxc.txt 8>&1 1>&2 2>&8 | wc -c
40
vagrant@vagrant:~$ echo tttttt > zxc.txt
vagrant@vagrant:~$ cat zxc.txt 8>&1 1>&2 2>&8 | wc -c
tttttt
0
создали новый дескриптор, затем поменял стандартные потоки местами через промежуточный новый дескриптор

9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:

vagrant@netology1:~$ ssh localhost 'tty'
not a tty
Почитайте, почему так происходит, и как изменить поведение.

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
