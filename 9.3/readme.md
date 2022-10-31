# Домашнее задание к занятию "09.03 CI\CD"

## Подготовка к выполнению

1. Создаём 2 VM в yandex cloud со следующими параметрами: 2CPU 4RAM Centos7(остальное по минимальным требованиям)
![image](https://user-images.githubusercontent.com/99823951/198934504-82875048-da42-4e7d-85fc-2c14b3db50a4.png)
2. Прописываем в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook'a](./infrastructure/site.yml) созданные хосты
3. Добавляем в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе - найдите таску в плейбуке, которая использует id_rsa.pub имя и исправьте на своё
4. Запускаем playbook, ожидаем успешного завершения
```bash
[centos@localhost playbook]$ ansible-playbook -i inventory/host.yml site.yml

PLAY [Get OpenJDK installed] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [sonar-01]

TASK [install unzip] ***********************************************************
changed: [sonar-01]

TASK [Upload .tar.gz file conaining binaries from remote storage] **************
changed: [sonar-01]

TASK [Ensure installation dir exists] ******************************************
changed: [sonar-01]

TASK [Extract java in the installation directory] ******************************
changed: [sonar-01]

TASK [Export environment variables] ********************************************
changed: [sonar-01]

PLAY [Get PostgreSQL installed] ************************************************

TASK [Gathering Facts] *********************************************************
ok: [sonar-01]

TASK [Change repo file] ********************************************************
changed: [sonar-01]

TASK [Install PostgreSQL repos] ************************************************
changed: [sonar-01]

TASK [Install PostgreSQL] ******************************************************
changed: [sonar-01]

TASK [Init template1 DB] *******************************************************
changed: [sonar-01]

TASK [Start pgsql service] *****************************************************
changed: [sonar-01]

TASK [Create user in system] ***************************************************
changed: [sonar-01]

TASK [Create user for Sonar in PostgreSQL] *************************************
[WARNING]: Module remote_tmp /var/lib/pgsql/.ansible/tmp did not exist and was
created with a mode of 0700, this may cause issues when running as another
user. To avoid this, create the remote_tmp dir with the correct permissions
manually
changed: [sonar-01]

TASK [Change password for Sonar user in PostgreSQL] ****************************
changed: [sonar-01]

TASK [Create Sonar DB] *********************************************************
changed: [sonar-01]

TASK [Copy pg_hba.conf] ********************************************************
changed: [sonar-01]

PLAY [Prepare Sonar host] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [sonar-01]

TASK [Create group in system] **************************************************
ok: [sonar-01]

TASK [Create user in system] ***************************************************
ok: [sonar-01]

TASK [Set up ssh key to access for managed node] *******************************
changed: [sonar-01]

TASK [Allow group to have passwordless sudo] ***********************************
changed: [sonar-01]

TASK [Increase Virtual Memory] *************************************************
changed: [sonar-01]

TASK [Reboot VM] ***************************************************************
changed: [sonar-01]

PLAY [Get Sonarqube installed] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [sonar-01]

TASK [Get distrib ZIP] *********************************************************
changed: [sonar-01]

TASK [Unzip Sonar] *************************************************************
changed: [sonar-01]

TASK [Move Sonar into place.] **************************************************
changed: [sonar-01]

TASK [Configure SonarQube JDBC settings for PostgreSQL.] ***********************
changed: [sonar-01] => (item={u'regexp': u'^sonar.jdbc.username', u'line': u'sonar.jdbc.username=sonar'})
changed: [sonar-01] => (item={u'regexp': u'^sonar.jdbc.password', u'line': u'sonar.jdbc.password=sonar'})
changed: [sonar-01] => (item={u'regexp': u'^sonar.jdbc.url', u'line': u'sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance'})
changed: [sonar-01] => (item={u'regexp': u'^sonar.web.context', u'line': u'sonar.web.context='})

TASK [Generate wrapper.conf] ***************************************************
changed: [sonar-01]

TASK [Symlink sonar bin.] ******************************************************
changed: [sonar-01]

TASK [Copy SonarQube systemd unit file into place (for systemd systems).] ******
changed: [sonar-01]

TASK [Ensure Sonar is running and set to start on boot.] ***********************
changed: [sonar-01]

TASK [Allow Sonar time to build on first start.] *******************************
Pausing for 180 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [sonar-01]

TASK [Make sure Sonar is responding on the configured port.] *******************
ok: [sonar-01]

PLAY [Get Nexus installed] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [nexus-01]

TASK [Create Nexus group] ******************************************************
changed: [nexus-01]

TASK [Create Nexus user] *******************************************************
changed: [nexus-01]

TASK [Install JDK] *************************************************************
changed: [nexus-01]

TASK [Create Nexus directories] ************************************************
changed: [nexus-01] => (item=/home/nexus/log)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
changed: [nexus-01] => (item=/home/nexus/pkg)
changed: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] **********************************************************
[WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was
created with a mode of 0700, this may cause issues when running as another
user. To avoid this, create the remote_tmp dir with the correct permissions
manually
changed: [nexus-01]

TASK [Unpack Nexus] ************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] *************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] *******************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] *********************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ***************************************
[WARNING]: The value 65536 (type int) in a string field was converted to
u'65536' (type string). If this does not look like what you expect, quote the
entire value to ensure it does not change.
changed: [nexus-01]

TASK [Create Nexus service for SystemD] ****************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] *****************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] **************************************************
changed: [nexus-01]

TASK [Create Nexus properties] *************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] ****************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] ******************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ***************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] ******************************************
ok: [nexus-01]

PLAY RECAP *********************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
sonar-01                   : ok=35   changed=27   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
6. Проверяем готовность Sonarqube через [браузер](http://localhost:9000)
![image](https://user-images.githubusercontent.com/99823951/198935617-260de111-a4e2-4ca8-9e34-f64cd8fe6b7c.png)
7. Заходим под admin\admin, меняем пароль на свой
8.  Проверяем готовность Nexus через [бразуер](http://localhost:8081)
![image](https://user-images.githubusercontent.com/99823951/198935833-ea9f306f-3ddb-4c0c-8360-267e796fdcaa.png)
10. Подключаемся под admin\admin123, меняем пароль, сохраняем анонимный доступ

## Знакомоство с SonarQube

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
```bash
[centos@localhost example]$ sonar-scanner --version
INFO: Scanner configuration file: /home/centos/sonarscanner/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 3.10.0-1160.el7.x86_64 amd64
```
6. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
```bash
[centos@localhost example]$ sonar-scanner \
>   -Dsonar.projectKey=netology \
>   -Dsonar.sources=. \
>   -Dsonar.host.url=http://158.160.13.169:9000 \
>   -Dsonar.login=c97febc9b08717265a28edbb6f8ad7f25632d65c \
> -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/centos/sonarscanner/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 3.10.0-1160.el7.x86_64 amd64
INFO: User cache: /home/centos/.sonar/cache
INFO: Scanner configuration file: /home/centos/sonarscanner/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: Analyzing on SonarQube server 9.1.0
INFO: Default locale: "en_US", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=241ms
INFO: Server id: 9CFC3560-AYQsaiR8bvWI4YpTftvl
INFO: User cache: /home/centos/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=128ms
INFO: Load/download plugins (done) | time=42036ms
INFO: Process project properties
INFO: Process project properties (done) | time=15ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=1ms
INFO: Project key: netology
INFO: Base dir: /home/centos/git/netology_devops/9.3/example
INFO: Working dir: /home/centos/git/netology_devops/9.3/example/.scannerwork
INFO: Load project settings for component key: 'netology'
INFO: Load project settings for component key: 'netology' (done) | time=121ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=133ms
INFO: Load active rules
INFO: Load active rules (done) | time=3553ms
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 1 file indexed
INFO: 0 files ignored because of scm ignore settings
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module netology
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=118ms
INFO: Sensor Python Sensor [python]
WARN: Your code is analyzed as compatible with python 2 and 3 by default. This will prevent the detection of issues specific to python 2 or python 3. You can get a more precise analysis by setting a python version in your configuration via the parameter "sonar.python.version"
INFO: Starting global symbols computation
INFO: 1 source file to be analyzed
INFO: Load project repositories
INFO: Load project repositories (done) | time=117ms
INFO: 1/1 source file has been analyzed
INFO: Starting rules execution
INFO: 1 source file to be analyzed
INFO: 1/1 source file has been analyzed
INFO: Sensor Python Sensor [python] (done) | time=1589ms
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=6ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=0ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=0ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=2ms
INFO: Sensor C# Project Type Information [csharp]
INFO: Sensor C# Project Type Information [csharp] (done) | time=0ms
INFO: Sensor C# Analysis Log [csharp]
INFO: Sensor C# Analysis Log [csharp] (done) | time=56ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=1ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=0ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=2ms
INFO: Sensor VB.NET Project Type Information [vbnet]
INFO: Sensor VB.NET Project Type Information [vbnet] (done) | time=0ms
INFO: Sensor VB.NET Analysis Log [vbnet]
INFO: Sensor VB.NET Analysis Log [vbnet] (done) | time=11ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=0ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=0ms
INFO: SCM Publisher SCM provider for this project is: git
INFO: SCM Publisher 1 source file to be analyzed
INFO: SCM Publisher 0/1 source files have been analyzed (done) | time=179ms
WARN: Missing blame information for the following files:
WARN:   * fail.py
WARN: This may lead to missing/broken features in SonarQube
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=10ms
INFO: Analysis report generated in 151ms, dir size=103.2 kB
INFO: Analysis report compressed in 6ms, zip size=14.1 kB
INFO: Analysis report uploaded in 104ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://158.160.13.169:9000/dashboard?id=netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://158.160.13.169:9000/api/ce/task?id=AYQsjie9bvWI4YpTfy0s
INFO: Analysis total time: 9.596 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 59.841s
INFO: Final Memory: 8M/66M
INFO: ------------------------------------------------------------------------
```
8. Смотрим результат в интерфейсе
![image](https://user-images.githubusercontent.com/99823951/198939428-5e176c64-0940-4ec4-b679-edbc8647edeb.png)
8. Исправляем ошибки, которые он выявил(включая warnings)
9. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
![image](https://user-images.githubusercontent.com/99823951/198939982-cf8eacfb-6492-48c1-8be4-55fe43a88bf2.png)
11. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-releases` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
![image](https://user-images.githubusercontent.com/99823951/198955682-e673a073-274c-41ca-acbc-c5f857627abb.png)

5. В ответе присылаем файл [maven-metadata.xml](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/9.3/maven-metadata.xml) для этого артефекта

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
3. Удаляем из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем http соединение( раздел mirrors->id: my-repository-http-blocker)
4. Проверяем `mvn --version`
```bash
[centos@localhost Downloads]$ mvn -version
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /opt/maven
Java version: 1.8.0_352, vendor: Red Hat, Inc., runtime: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.352.b08-2.el7_9.x86_64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-1160.el7.x86_64", arch: "amd64", family: "unix"
```
6. Забираем директорию [mvn](./mvn) с pom

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
4. В ответе присылаем исправленный файл [pom.xml](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/9.3/pom.xml)


