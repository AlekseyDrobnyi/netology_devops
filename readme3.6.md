Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"  
1. Работа c HTTP через телнет.  
Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80  
отправьте HTTP запрос  
GET /questions HTTP/1.0  
HOST: stackoverflow.com  
[press enter]  
[press enter]  
В ответе укажите полученный HTTP код, что он означает?  

```
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.129.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 4f68334b-f5fd-498b-900c-5a614ba02410
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Mon, 18 Apr 2022 03:00:02 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19170-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1650250802.458361,VS0,VE92
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=b7b140f7-cd2b-0fb3-273a-a6d4894587d2; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
Как понял,ответ (HTTP/1.1 301 Moved Permanently ) обозначает, что ресурс перемещен сюда - location: https://stackoverflow.com/questions  


2. Повторите задание 1 в браузере, используя консоль разработчика F12.  
откройте вкладку Network  
отправьте запрос http://stackoverflow.com  
найдите первый ответ HTTP сервера, откройте вкладку Headers  
укажите в ответе полученный HTTP код.  
проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?  
приложите скриншот консоли браузера в ответ. 

Первым ответом со статусом 307 был - HTTP 307 Internal Redirect
```
Request URL: http://stackoverflow.com/
Request Method: GET
Status Code: 301 Moved Permanently
Remote Address: 151.101.193.69:80
Referrer Policy: strict-origin-when-cross-origin
```
Страница загрузилась за - Load: 1.40 s  
Дольше всего отрабатывался запрос - https://stackoverflow.com/  
![image](https://user-images.githubusercontent.com/99823951/163750401-31ba10f6-36b8-4106-9792-da1a8032ae90.png)

 

3. Какой IP адрес у вас в интернете?  
178.187.129.102

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
Провайдер указан как - OJSC "Sibirtelecom", автономная система - AS12389

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой ```traceroute```
```
vagrant@vagrant:~$ traceroute -AnI 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.193 ms  0.180 ms  0.176 ms
 2  192.168.0.1 [*]  4.062 ms  4.057 ms  4.053 ms
 3  213.228.116.79 [AS12389]  3.714 ms  4.045 ms  5.570 ms
 4  213.228.107.2 [AS12389]  6.828 ms  7.159 ms  7.094 ms
 5  87.226.183.89 [AS12389]  49.130 ms  49.554 ms  49.513 ms
 6  74.125.51.172 [AS15169]  49.504 ms  48.462 ms  49.276 ms
 7  108.170.250.51 [AS15169]  48.112 ms  47.449 ms  48.169 ms
 8  216.239.51.32 [AS15169]  63.007 ms  63.352 ms  63.303 ms
 9  172.253.66.110 [AS15169]  67.438 ms  67.713 ms  67.709 ms
10  216.239.47.203 [AS15169]  65.968 ms  65.365 ms  65.960 ms
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  8.8.8.8 [AS15169]  64.232 ms  63.546 ms  64.147 ms
```

6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
```
                                  My traceroute  [v0.93]
vagrant (10.0.2.15)                                              2022-04-18T04:14:45+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                 Packets               Pings
Host                                                                        Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2                                                         0.0%    39    0.3   0.2   0.1   0.4   0.1
 2. AS???    192.168.0.1                                                      0.0%    39    1.3   1.0   0.8   2.3   0.2
 3. AS12389  213.228.116.79                                                   0.0%    39    2.9   4.0   2.6  32.8   4.9
 4. AS12389  213.228.107.2                                                    0.0%    39    6.7   6.8   2.9  33.2   6.8
 5. AS12389  87.226.183.89                                                    0.0%    39   47.8  48.5  47.3  60.2   2.4
 6. AS15169  74.125.51.172                                                    0.0%    39   47.9  47.9  47.4  50.9   0.8
 7. AS15169  108.170.250.51                                                   0.0%    39   47.6  50.2  47.1  76.0   6.2
 8. AS15169  216.239.51.32                                                   20.5%    39   64.1  63.6  62.5  71.6   1.8
 9. AS15169  172.253.66.110                                                   0.0%    39   68.1  65.0  64.4  68.1   0.6
10. AS15169  216.239.47.203                                                   0.0%    39   64.8  64.9  64.4  65.6   0.3
11. (waiting for reply)
12. (waiting for reply)
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. AS15169  8.8.8.8                                                          0.0%    38   63.1  63.0  62.6  65.1   0.4
```
Наибольшая задерка, по сравнению с остальными, у этих AS:  
AS15169  216.239.51.32  
AS15169  172.253.66.110   
AS15169  216.239.47.203   

так и еще на одной из них идет 20% потеря пакетов.  

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig

```
vagrant@vagrant:~$ dig +short A dns.google
8.8.8.8
8.8.4.4
vagrant@vagrant:~$ dig +short NS dns.google
ns3.zdns.google.
ns1.zdns.google.
ns2.zdns.google.
ns4.zdns.google.
```

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig  
```
vagrant@vagrant:~$ dig +noall +answer -x 8.8.8.8
8.8.8.8.in-addr.arpa.   4698    IN      PTR     dns.google.
vagrant@vagrant:~$ dig +noall +answer -x 8.8.4.4
4.4.8.8.in-addr.arpa.   44550   IN      PTR     dns.google.
```

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.
