1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.  
![Снимок экрана 2022-05-07 091921](https://user-images.githubusercontent.com/99823951/167234132-8e8c3bdb-84e4-48be-b862-9aee8c24ace3.jpg)


2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  
Настроил, отсканировал qr-код.
![image](https://user-images.githubusercontent.com/99823951/167234721-d02975a4-bd6b-44d3-a566-a5c305f8054a.png)

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  
```
vagrant@vagrant:~$ sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-05-07 03:11:46 UTC; 6s ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 4301 ExecStart=/usr/sbin/apachectl start (code=exited, status=0/SUCCESS)
   Main PID: 4316 (apache2)
      Tasks: 55 (limit: 1071)
     Memory: 6.0M
     CGroup: /system.slice/apache2.service
             ├─4316 /usr/sbin/apache2 -k start
             ├─4317 /usr/sbin/apache2 -k start
             └─4318 /usr/sbin/apache2 -k start

May 07 03:11:46 vagrant systemd[1]: Starting The Apache HTTP Server...
May 07 03:11:46 vagrant apachectl[4314]: AH00558: apache2: Could not reliably determine the server's fully qualified do>
May 07 03:11:46 vagrant systemd[1]: Started The Apache HTTP Server.
```
```
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.k
ey -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=10.0.2.15"
Generating a RSA private key
..........................................................+++++
.....+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
```
```
vagrant@vagrant:~$ sudo mkdir /var/www/10.0.2.15
vagrant@vagrant:~$ sudo nano var/www/10.0.2.15/index.html
vagrant@vagrant:~$ ls /var/www/
10.0.2.15  192.168.10.10  html
vagrant@vagrant:~$ ls /var/www/10.0.2.15
vagrant@vagrant:~$ ls /var/www/192.168.10.10
index.html
vagrant@vagrant:~$ sudo nano /var/www/10.0.2.15/index.html
vagrant@vagrant:~$ sudo nano /etc/apache2/sites-available/10.0.2.15.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName 10.0.2.15
    ServerAlias 10.0.2.15
    DocumentRoot /var/www/10.0.2.15
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>

vagrant@vagrant:~$ sudo a2ensite 10.0.2.15.conf
Enabling site 10.0.2.15.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@vagrant:~$ sudo apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
vagrant@vagrant:~$ sudo systemctl restart apache2
vagrant@vagrant:~$ curl 10.0.2.15
<html>
    <head>
        <title>Welcome to Your_domain!</title>
    </head>
    <body>
        <h1>Success!  The your_domain virtual host is working!</h1>
    </body>
</html>
```




4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, 
РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).  

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  

6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.  

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  
