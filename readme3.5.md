Домашнее задание к занятию "3.5. Файловые системы"  
1. Узнайте о sparse (разряженных) файлах.  
почитал

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  

Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.   

vagrant@vagrant:~$ ln text.txt tesl_link  
vagrant@vagrant:~$ ls -ilh  
total 0  
1048605 -rw-rw-r-- 2 vagrant vagrant 0 Apr  6 04:55 tesl_link  
1048605 -rw-rw-r-- 2 vagrant vagrant 0 Apr  6 04:55 text.txt  

vagrant@vagrant:~$ chmod 0000 text.txt

vagrant@vagrant:~$ ls -ilh
total 0
1048605 ---------- 2 vagrant vagrant 0 Apr  6 04:55 tesl_link
1048605 ---------- 2 vagrant vagrant 0 Apr  6 04:55 text.txt

3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
Выполнил

vagrant@vagrant:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128  
loop2                       7:2    0 70.3M  1 loop /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop /snap/snapd/15314  
loop5                       7:5    0 61.9M  1 loop /snap/core20/1405  
loop6                       7:6    0 67.8M  1 loop /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /  
sdb                         8:16   0  2.5G  0 disk  
sdc                         8:32   0  2.5G  0 disk  

4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  
разбил раздел, пользовался ключами m(помощь), p(посмотреть разделы), n(создать раздел), w(сохранить и выйти):  

vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4f342fac

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G  5 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux


5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

vagrant@vagrant:~$ sudo -i

root@vagrant:~# sfdisk -d /dev/sdb | sfdisk --force /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x4f342fac.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x4f342fac

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
root@vagrant:~#

проверяем sudo sfdisk -l

Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4f342fac

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux


Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4f342fac

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux


6. Соберите mdadm RAID1 на паре разделов 2 Гб.

root@vagrant:~# mdadm --create --verbose /dev/md0 -l1 -n 2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

проверяем  lsblk:

sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part

7. Соберите mdadm RAID0 на второй паре маленьких разделов.

почему-то при создании raid0 не было опроса Y/N на подтверждение. Сразу произошло создание.

root@vagrant:~# mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b2,c2}
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.

sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0

8. Создайте 2 независимых PV на получившихся md-устройствах.

root@vagrant:~# pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
  
  root@vagrant:~# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               ubuntu-vg
  PV Size               <63.00 GiB / not usable 0
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              16127
  Free PE               8063
  Allocated PE          8064
  PV UUID               sDUvKe-EtCc-gKuY-ZXTD-1B1d-eh9Q-XldxLf

  --- Physical volume ---
  PV Name               /dev/md0
  VG Name               vg01
  PV Size               <2.00 GiB / not usable 0
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              511
  Free PE               511
  Allocated PE          0
  PV UUID               vUlumX-S2aO-TH3u-6Bue-3Pu2-Pu9G-FRAdUQ

  --- Physical volume ---
  PV Name               /dev/md1
  VG Name               vg01
  PV Size               1018.00 MiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              254
  Free PE               254
  Allocated PE          0
  PV UUID               HRuXG4-wjcD-d04Y-7zzo-rUu9-H6OA-X3cQcH

9. Создайте общую volume-group на этих двух PV.

root@vagrant:~# vgcreate vg01 /dev/md0 /dev/md1
  Volume group "vg01" successfully created
  
 root@vagrant:~# vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.00 GiB
  PE Size               4.00 MiB
  Total PE              16127
  Alloc PE / Size       8064 / 31.50 GiB
  Free  PE / Size       8063 / <31.50 GiB
  VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

  --- Volume group ---
  VG Name               vg01
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               kVU9JD-GEix-2IL5-ivt8-Gl6j-vnQJ-HaZe4I
  

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

root@vagrant:~# lvcreate -L 100 vg01 /dev/md1
  Logical volume "lvol0" created.
 
root@vagrant:~# lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ubuntu-lv ubuntu-vg -wi-ao----  31.50g
  lvol0     vg01      -wi-a----- 100.00m

11. Создайте mkfs.ext4 ФС на получившемся LV.

root@vagrant:~# mkfs.ext4 /dev/vg01/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done


12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

root@vagrant:~# mkdir /tmp/new

root@vagrant:~# mount /dev/vg01/lvol0 /tmp/new

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-04-06 04:26:08--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22383592 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  21.35M  10.2MB/s    in 2.1s

2022-04-06 04:26:10 (10.2 MB/s) - ‘/tmp/new/test.gz’ saved [22383592/22383592]

root@vagrant:~# ls -l /tmp/new
total 21876
drwx------ 2 root root    16384 Apr  6 04:04 lost+found
-rw-r--r-- 1 root root 22383592 Apr  6 03:58 test.gz





14. Прикрепите вывод lsblk.

root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT  
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128  
loop2                       7:2    0 70.3M  1 loop  /snap/lxd/21029  
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2344  
loop4                       7:4    0 44.7M  1 loop  /snap/snapd/15314  
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1405  
loop6                       7:6    0 67.8M  1 loop  /snap/lxd/22753  
sda                         8:0    0   64G  0 disk  
├─sda1                      8:1    0    1M  0 part  
├─sda2                      8:2    0    1G  0 part  /boot  
└─sda3                      8:3    0   63G  0 part  
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /  
sdb                         8:16   0  2.5G  0 disk  
├─sdb1                      8:17   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdb2                      8:18   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new  
   sdc                         8:32   0  2.5G  0 disk  
├─sdc1                      8:33   0    2G  0 part  
│ └─md0                     9:0    0    2G  0 raid1  
└─sdc2                      8:34   0  511M  0 part  
  └─md1                     9:1    0 1018M  0 raid0  
   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new  


15. Протестируйте целостность файла:

проверил:

root@vagrant:~# gzip -t /tmp/new/test.gz

root@vagrant:~# echo $?
0

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

root@vagrant:~# pvmove /dev/md1
  /dev/md1: Moved: 12.00%
  /dev/md1: Moved: 100.00%
  
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
....
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
│   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/new
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0

17. Сделайте --fail на устройство в вашем RAID1 md.

root@vagrant:~# mdadm /dev/md0 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0


root@vagrant:~# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Apr  6 03:28:11 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Wed Apr  6 04:41:56 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:0  (local to host vagrant)
              UUID : e4bad6a6:37093efd:7e54f9a1:435d95ce
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1

18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

root@vagrant:~# dmesg | grep md0
[ 4329.174431] md/raid1:md0: not clean -- starting background reconstruction
[ 4329.174432] md/raid1:md0: active with 2 out of 2 mirrors
[ 4329.174443] md0: detected capacity change from 0 to 2144337920
[ 4329.176019] md: resync of RAID array md0
[ 4339.859419] md: md0: resync done.
[ 8753.390042] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

Проверил: root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0

20. Погасите тестовый хост, vagrant destroy.

Алексей@DESKTOP-8UA2JLC MINGW64 ~/desktop/devops/systemadm (master)
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
