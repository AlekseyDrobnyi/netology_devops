# Домашнее задание к занятию "Компьютерные сети.Лекция 2"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с инструментами настройки сети в Linux, агрегации нескольких сетевых интерфейсов, отладки их работы.
2. Примените знания о сетевых адресах на практике для проектирования сети.

------

## Задание

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?  
```bash
vagrant@vagrant:~$ ip -c -br link  
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>  
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>  
```
в windows в командной строке - `ipconfig /all`

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?  

Link Layer Discovery Protocol (LLDP) — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть информацию о себе и о своих возможностях, а также собирать эту информацию о соседних устройствах.  

установка пакета `sudo apt install lldpd`

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.  

Используется VLAN – это аббревиатура, означающая Virtual Local Area Network (виртаульная локальная сеть).  
```bash
vagrant@vagrant:~$ sudo apt install vlan
```  
На Linux необходимо проверить наличие модуля 8021q. Если он не подгружен, то выполнить команду `sudo modprobe 8021q`
```bash
vagrant@vagrant:~$ lsmod | grep 8021q
8021q                  32768  0
garp                   16384  1 8021q
mrp                    20480  1 8021q
```
добавление `vlan` через `vconfig`  
```bash
vagrant@vagrant:~$ vconfig add eth0 5
```

```bash
vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.200@eth0    DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
eth0.5@eth0      DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
```
удаление `Vlan`  
```bash
vagrant@vagrant:~$ vconfig rem eth0.5
```
```bash
vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.200@eth0    DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
```

так же можно через `IP` создать `Vlan`  
```nash
vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.55 type vlan id 55
```
```bash
vagrant@vagrant:~$ ip -d link show eth0.55
5: eth0.55@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 55 <REORDER_HDR> addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
 ```

В обоих случаях `Vlan-ы` после перезагрузки системы будут удалены. Поэтому чтобы сделать их постоянными, необходимо отредактировать `etplan`

```bash
vagrant@vagrant:~$ sudo cat /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
  vlans:
    eth0.55:
      id: 55
      link: eth0
      addresses: [192.168.55.10/24]
 ```
 ```bash
 vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.200@eth0    DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
eth0.55@eth0     UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.    
Bonding – это механизм, используемый Linux-серверами и предполагающий связь нескольких физических интерфейсов в один виртуальный, что позволяет обеспечить большую пропускную способность или отказоустойчивость в случае повреждения кабеля.  
Типы агрегации:  
`Mode-0(balance-rr)`  
`Mode-1(active-backup)`    
`Mode-2(balance-xor)`  
`Mode-3(broadcast)` 
`Mode-4(802.3ad)`  
`Mode-5(balance-tlb)`   
`Mode-6(balance-alb)`   

```bash
vagrant@vagrant:~$ sudo cat /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
    eth1:
      dhcp4: no
    eth2:
      dhcp4: no
  bonds:
   bond0:
    addresses: [192.168.55.20/24]
    interfaces: [eth1, eth2]
    parameters:
      mode: balance-rr
 ```
 ```bash
 vagrant@vagrant:~$ ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.200@eth0    DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
eth0.55@eth0     UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
bond0            DOWN           92:7a:bd:bc:8f:c3 <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP>
```


5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.  
В сети с маской /29 всего 8 адресов. из которых 2 всегда зарезервированы под сеть и broadcast  

В сети /24 можно получить 32 подсети /29. 

10.10.10.0/29, где 0 и 7 зарезервированы
10.10.10.8/29, где 8 и 15 зарезервированы и т.п.
10.10.10.16/29  

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.    

взять сеть 100.64.0.0 и маску 26. Как раз получится 62 адреса. Если брать маску 27, то уже не хватит ip-адресов на все хосты.

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?  
в windows:
`arp -a` - посмотреть таблицу  
`arp -d` удалить кэш-таблицу  
`arp -d <ip-address` - удалить конкретный адрес  
в Ubuntu:  
`ip neighbour show` - показать ARP таблицу  
`ip neighbour del [ip address] dev [interface]` - удалить из ARP таблицы конкретный адрес  
`ip neighbour flush all` - очищает таблицу ARP  


