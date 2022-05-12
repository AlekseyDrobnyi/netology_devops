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

```
vagrant@vagrant:~$ curl --insecure -v https://10.0.2.15
*   Trying 10.0.2.15:443...
* TCP_NODELAY set
* Connected to 10.0.2.15 (10.0.2.15) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=RU; ST=Example; L=Example; O=Example; CN=10.0.2.15 emailAddress=test@example.com
*  start date: May 07 11:15:22 2022 GMT
*  expire date: May 07 11:15:22 2023 GMT
*  issuer: C=RU; ST=Example; L=Example; O=Example; CN=10.0.2.15; emailAddress=test@example.com
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
> GET / HTTP/1.1
> Host: 10.0.2.15
> User-Agent: curl/7.74.0
> Accept: */*
>
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sat, May 07 11:15:22 GMT
< Server: Apache/2.4.48 (Ubuntu)
< Last-Modified: Sat, May 07 11:15:22 GMT
< ETag: "14-5d6b9bbc20d84"
< Accept-Ranges: bytes
< Content-Length: 20
< Content-Type: text/html
<
<h1>Success!  The your_domain virtual host is working!</h1>
* Connection #0 to host 10.0.2.15 left intact
```



4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, 
РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).  
```
vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://netology.ru/
 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
```

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  
```
vagrant@vagrant:~$ systemctl status sshd.service
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-04-26 03:44:17 UTC; 2 weeks 0 days ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 693 (sshd)
      Tasks: 1 (limit: 1071)
     Memory: 6.7M
     CGroup: /system.slice/ssh.service
             └─693 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
```             
```
vagrant@vagrant:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:p3BAlIlIk4ZoEAJonm0XrCz/NZ8g/QotKSkHP2CFOzE vagrant@vagrant
The key's randomart image is:
+---[RSA 3072]----+
|X+oo.ooo         |
|=o=..+o          |
|+E+.. o          |
| +== . .         |
| *+ . o S .      |
|. =...oB o       |
| . *.+o.* .      |
|  o o.o  +       |
|       ..        |
+----[SHA256]-----+
```
```
vagrant@vagrant:~$ ssh-copy-id vagrant@10.0.2.15

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host '10.0.2.15 (10.0.2.15)' can't be established.
ECDSA key fingerprint is SHA256:/rZjeIEeI4GXObGdc6iTj7LjwLh3TA1bwOPXEHLrkaM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@10.0.2.15's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@10.0.2.15'"
and check to make sure that only the key(s) you wanted were added.

vagrant@vagrant:~$ ssh vagrant@10.0.2.15
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 11 May 2022 02:56:41 AM UTC


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed May 11 02:56:4 2022 from 10.0.2.2
```
             
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.  

```
vagrant@vagrant:~$ mv /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/linux2_rsa
vagrant@vagrant:~$ touch ~/.ssh/config && chmod 600 ~/.ssh/config
vagrant@vagrant:~$ nano .ssh/config

Host linux2
     HostName 10.5.5.5
     User vagrant
     IdentityFile ~/.ssh/linux2_rsa
     
vagrant@vagrant:~$ ssh linux2
Welcome to Ubuntu 21.10 (GNU/Linux 5.13.0-22-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Jan 29 03:21:15 PM UTC 2022

  System load:  0.0                Processes:             113
  Usage of /:   11.6% of 30.83GB   Users logged in:       1
  Memory usage: 20%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1: 10.5.5.5


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Jan 29 15:12:03 2022 from 10.5.5.2
```
8. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  
