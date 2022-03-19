1. Установите средство виртуализации Oracle VirtualBox.
уже было установлено на ПК

2. Установите средство автоматизации Hashicorp Vagrant.
Установлено

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:
Windows Terminal в Windows

4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
Выполнено

5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
RAM: 1024 MB
CPU: 2 CPU
SataControler: 64 GB
video: 4 MB

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end

7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
Выполнено

8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
HISTFILESIZE - The maximum number of lines contained in the history file. line 846 (Максимальное количество строк, содержащихся в файле истории)
HISTSIZE - The number of commands to remember in the command history (see HISTORY below). line 862 (Количество команд, которые нужно запомнить в истории команд)

что делает директива ignoreboth в bash?
ignoreboth is shorthand for ignorespace and ignoredups. (является сокращением для ignorespace и ignoredups)
ignorespace - lines which begin with a space character are not saved in  the  history list. (строки, начинающиеся с пробела, не сохраняются в списке истории)
ignoredups - causes lines matching the previous history entry to not be saved. (заставляет строки, соответствующие предыдущей записи истории, не сохраняться)

9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
( and ), { and } are reserved words and must occur where a reserved  word  is permitted  to be recognized. line 221 (являются зарезервированными словами и должны встречаться там, где разрешено распознавание зарезервированного слова.) используются в различных циклах

10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
 touch {000001..100000}.txt - создалось 100000 .txt файлов в текущей дериктории
 
 touch {000001..300000}.txt - не создает, т.к. сильно большое значение
-bash: /usr/bin/touch: Argument list too long

11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
[[ expression ]] Return a status of 0 or 1 depending on the evaluation of the conditional  expression  expression. (Возвращает статус 0 или 1 в зависимости от условного выражения.) проверяет наличие каталого tmp

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash

vagrant@vagrant:~$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:~$ mkdir /tmp/new_path_directory/
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory/
vagrant@vagrant:~$ path=/tmp/new_path_directory/:$PATH
vagrant@vagrant:~$ type -a bash

bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

13. Чем отличается планирование команд с помощью batch и at?
Команда at используется для назначения одноразового задания на заданное время, 
а команда batch — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8

14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
vagrant suspend
