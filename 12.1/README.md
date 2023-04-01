# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl»


------

### Чеклист готовности к домашнему заданию

1. Личный компьютер с ОС Linux или MacOS 

или 

2. ВМ c ОС Linux в облаке либо ВМ на локальной машине для установки MicroK8S  

------

### Инструкция к заданию

1. Установка MicroK8S:
    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - добавить локального пользователя в группу `sudo usermod -a -G microk8s $USER`,
    - изменить права на папку с конфигурацией `sudo chown -f -R $USER ~/.kube`.

2. Полезные команды:
    - проверить статус `microk8s status --wait-ready`;
    - подключиться к microK8s и получить информацию можно через команду `microk8s command`, например, `microk8s kubectl get nodes`;
    - включить addon можно через команду `microk8s enable`; 
    - список addon `microk8s status`;
    - вывод конфигурации `microk8s config`;
    - проброс порта для подключения локально `microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443`.

3. Настройка внешнего подключения:
    - отредактировать файл /var/snap/microk8s/current/certs/csr.conf.template
    ```shell
    # [ alt_names ]
    # Add
    # IP.4 = 123.45.67.89
    ```
    - обновить сертификаты `sudo microk8s refresh-certs --cert front-proxy-client.crt`.

4. Установка kubectl:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;
    - chmod +x ./kubectl;
    - sudo mv ./kubectl /usr/local/bin/kubectl;
    - настройка автодополнения в текущую сессию `bash source <(kubectl completion bash)`;
    - добавление автодополнения в командную оболочку bash `echo "source <(kubectl completion bash)" >> ~/.bashrc`.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.
3. [Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.

------

### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.
![image](https://user-images.githubusercontent.com/99823951/224987838-c009c3be-9954-4e9f-a125-85a9d8fb2beb.png)
Создал в ЯО ВМ
```bash
ubuntu@k8s:~$ sudo snap install microk8s --classic
microk8s (1.26/stable) v1.26.1 from Canonical✓ installed
```
```bash
ubuntu@k8s:~$ sudo microk8s status --wait-ready
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
```
Проверяю конфиг, он пригодится для дальнейшей настройки локального подключения.
```bash 
ubuntu@k8s:~$ sudo microk8s config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREekNDQWZlZ0F3SUJBZ0lVSkIvamJRRy9HeHE3QjN6SmVjK1Q5OUY0ekc0d0RRWUpLb1pJaHZjTkFRRUwKQlFBd0Z6RVZNQk1HQTFVRUF3d01NVEF1TVRVeUxqRTRNeTR4TUI0WERUSXpNRE14TkRBNU5URXhORm9YRFRNegpNRE14TVRBNU5URXhORm93RnpFVk1CTUdBMVVFQXd3TU1UQXVNVFV5TGpFNE15NHhNSUlCSWpBTkJna3Foa2lHCjl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF5WU5VazF6bnpLU1dERmsvUTF1VlVhU0M2b0FtcE5NRVFlTDAKbDVjUmNNaHBSM0hERC9VbXA5cVQ4UkkyKzBEQitQOFZNalVJNjg1MUlLRmkvajZybTJNWklxd1dCYkQxNlpxSQptaHVWWGpJSGI2TUpjZ2laVDUzNjFTMElwdXZ6bjdEazdoSGtDeHZOZUMvYnAwN2RnNVhEaEhnemc5Vk53bDlMCnBTaEo2UWE0NWsyQlcxYTA2R2I2aXNLeDMvZkc5UW9qNGl3a3hSRUo5c0Y5YXRNeGlrSzE5WFNTMHlocWJHOVMKTDJSVlZMQU9mRWZ1Z21wNDlyUmUvLy92OGJVMG4vSHVnLzk4bzFaU0JHNjhrNldjSGY2Qmp1OXFrMVQyanJadQpid2xlemN6bkZ3UTZOR0d3NDBteXJONmlVZldsNzFjc0JoYjlmUk1MRXFZNFV5cFFMd0lEQVFBQm8xTXdVVEFkCkJnTlZIUTRFRmdRVXB6cWdrZmN5UWRkeklyRWJaOVVaaEZUd3lISXdId1lEVlIwakJCZ3dGb0FVcHpxZ2tmY3kKUWRkeklyRWJaOVVaaEZUd3lISXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQwpBUUVBR3lUQjd4UnBXNXlCZDBjbC9GMWhnOHZFSVVUQ1ZYZGo5RE5xeVZUbGR0OFRqVUtiTWs3OG9RbFlxUUpiCmlMdjgzckRMbXF4a1lXcy9Zcml2ck81bWtYYVc1bFFnWkd1cEpSMGk2bHcxakhWb2FaT2RrR1puYlBmZ2dGNXMKc05IOGZRb0xTVm5vV1d4UnJxaDM4QjRZNWw1V1c4SVhZQVBUNE1Ed0dGQnJ6QysrQ01nVm05RzRGWUthSkx6UwpPUXRKazdpQjQvZmRiMmdRV3FBNTJWb3QvcTVhVTJFNG9ncG50T2xET1dBeitQb28wMXY0a0MyOU44R2NDTUU0ClN6N2U4L2lWTE4zMjdWTFR1cmN1WFdRdWhXMEV0Y0tOQmVsMWxFdFQ0NFpHNXJHVFpHQzV1Q2lYM2FtTXFjdkYKMnQwcFlEMmh1bWswZENKeTFMQjFMd0p6R1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.129.0.11:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: N0l1aUsrVzJMZjg5OVJMaG1ZOGI5SDBtV0NTdnJZNnlRd01YT2xDRWlSRT0K
```
  
  
  
2. Установить dashboard.
```bash
ubuntu@k8s:~$ sudo microk8s.enable dashboard
Infer repository core for addon dashboard
Enabling Kubernetes Dashboard
Infer repository core for addon metrics-server
Enabling Metrics-Server
serviceaccount/metrics-server created
```

3 Сгенерировать сертификат для подключения к внешнему ip-адресу.
добавляю внешний ip адрес в `csr.conf.template` и обновляю сертификат.
```bash
ubuntu@k8s:~$ sudo cat /var/snap/microk8s/current/certs/csr.conf.template
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = GB
ST = Canonical
L = Canonical
O = Canonical
OU = Canonical
CN = 127.0.0.1

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
IP.1 = 127.0.0.1
IP.2 = 10.152.183.1
IP.4 = 158.160.22.220
#MOREIPS

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment,digitalSignature
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names


ubuntu@k8s:~$ sudo microk8s refresh-certs --cert front-proxy-client.crt
Taking a backup of the current certificates under /var/snap/microk8s/4595/certs-backup/
Creating new certificates
Signature ok
subject=CN = front-proxy-client
Getting CA Private Key
Restarting service kubelite.
```

------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.
Скачиваю и устанавливаю `kubectl` на ВМ, с которой планируем подключаться к кластеру K8S.

```bash
ubuntu@ubuntu-VirtualBox:~$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 45.8M  100 45.8M    0     0  19.2M      0  0:00:02  0:00:02 --:--:-- 19.2M

ubuntu@ubuntu-VirtualBox:~$ chmod +x ./kubectl
ubuntu@ubuntu-VirtualBox:~$ sudo mv ./kubectl /usr/local/bin/kubectl
[sudo] password for ubuntu: 
ubuntu@ubuntu-VirtualBox:~$ kubectl version --client
WARNING: This version information is deprecated and will be replaced with the output from kubectl version --short.  Use --output=yaml|json to get the full version.
Client Version: version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.2", GitCommit:"fc04e732bb3e7198d2fa44efa5457c7c6f8c0f5b", GitTreeState:"clean", BuildDate:"2023-02-22T13:39:03Z", GoVersion:"go1.19.6", Compiler:"gc", Platform:"linux/amd64"}
Kustomize Version: v4.5.7

```


2. Настроить локально подключение к кластеру.
Проверяю конфиг
```bash
ubuntu@ubuntu-VirtualBox:~$ kubectl config view
apiVersion: v1
clusters: null
contexts: null
current-context: ""
kind: Config
preferences: {}
users: null
```
Для подключения на ВМ с кластером K8S модернизирую конфиг на "локальной" машине.
```bash
ubuntu@ubuntu-VirtualBox:~$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREekNDQWZlZ0F3SUJBZ0lVSkIvamJRRy9HeHE3QjN6SmVjK1Q5OUY0ekc0d0RRWUpLb1pJaHZjTkFRRUwKQlFBd0Z6RVZNQk1HQTFVRUF3d01NVEF1TVRVeUxqRTRNeTR4TUI0WERUSXpNRE14TkRBNU5URXhORm9YRFRNegpNRE14TVRBNU5URXhORm93RnpFVk1CTUdBMVVFQXd3TU1UQXVNVFV5TGpFNE15NHhNSUlCSWpBTkJna3Foa2lHCjl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF5WU5VazF6bnpLU1dERmsvUTF1VlVhU0M2b0FtcE5NRVFlTDAKbDVjUmNNaHBSM0hERC9VbXA5cVQ4UkkyKzBEQitQOFZNalVJNjg1MUlLRmkvajZybTJNWklxd1dCYkQxNlpxSQptaHVWWGpJSGI2TUpjZ2laVDUzNjFTMElwdXZ6bjdEazdoSGtDeHZOZUMvYnAwN2RnNVhEaEhnemc5Vk53bDlMCnBTaEo2UWE0NWsyQlcxYTA2R2I2aXNLeDMvZkc5UW9qNGl3a3hSRUo5c0Y5YXRNeGlrSzE5WFNTMHlocWJHOVMKTDJSVlZMQU9mRWZ1Z21wNDlyUmUvLy92OGJVMG4vSHVnLzk4bzFaU0JHNjhrNldjSGY2Qmp1OXFrMVQyanJadQpid2xlemN6bkZ3UTZOR0d3NDBteXJONmlVZldsNzFjc0JoYjlmUk1MRXFZNFV5cFFMd0lEQVFBQm8xTXdVVEFkCkJnTlZIUTRFRmdRVXB6cWdrZmN5UWRkeklyRWJaOVVaaEZUd3lISXdId1lEVlIwakJCZ3dGb0FVcHpxZ2tmY3kKUWRkeklyRWJaOVVaaEZUd3lISXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQwpBUUVBR3lUQjd4UnBXNXlCZDBjbC9GMWhnOHZFSVVUQ1ZYZGo5RE5xeVZUbGR0OFRqVUtiTWs3OG9RbFlxUUpiCmlMdjgzckRMbXF4a1lXcy9Zcml2ck81bWtYYVc1bFFnWkd1cEpSMGk2bHcxakhWb2FaT2RrR1puYlBmZ2dGNXMKc05IOGZRb0xTVm5vV1d4UnJxaDM4QjRZNWw1V1c4SVhZQVBUNE1Ed0dGQnJ6QysrQ01nVm05RzRGWUthSkx6UwpPUXRKazdpQjQvZmRiMmdRV3FBNTJWb3QvcTVhVTJFNG9ncG50T2xET1dBeitQb28wMXY0a0MyOU44R2NDTUU0ClN6N2U4L2lWTE4zMjdWTFR1cmN1WFdRdWhXMEV0Y0tOQmVsMWxFdFQ0NFpHNXJHVFpHQzV1Q2lYM2FtTXFjdkYKMnQwcFlEMmh1bWswZENKeTFMQjFMd0p6R1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://158.160.22.220:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: N0l1aUsrVzJMZjg5OVJMaG1ZOGI5SDBtV0NTdnJZNnlRd01YT2xDRWlSRT0K
```

Проверяю подключение

```bash
ubuntu@ubuntu-VirtualBox:~$ kubectl config get-contexts
CURRENT   NAME       CLUSTER            AUTHINFO   NAMESPACE
*         microk8s   microk8s-cluster   admin      
ubuntu@ubuntu-VirtualBox:~$ kubectl get nodes
NAME   STATUS   ROLES    AGE   VERSION
k8s    Ready    <none>   63m   v1.26.1
```
Запрашиваю расширенную информацию о нодах
```bash
ubuntu@ubuntu-VirtualBox:~$ kubectl get nodes -o wide
NAME   STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
k8s    Ready    <none>   68m   v1.26.1   10.129.0.11   <none>        Ubuntu 22.04.1 LTS   5.15.0-58-generic   containerd://1.6.8
ubuntu@ubuntu-VirtualBox:~$ kubectl describe nodes k8s
Name:               k8s
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=k8s
                    kubernetes.io/os=linux
                    microk8s.io/cluster=true
                    node.kubernetes.io/microk8s-controlplane=microk8s-controlplane
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    projectcalico.org/IPv4Address: 10.129.0.11/24
                    projectcalico.org/IPv4VXLANTunnelAddr: 10.1.77.0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Tue, 14 Mar 2023 16:52:02 +0700
```

3. Подключиться к дашборду с помощью port-forward.
Пробрасываю порт с "локальной" ВМ на ВМ в ЯО с кластером и дашбордом.
```bash
ubuntu@ubuntu-VirtualBox:~$ kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
Forwarding from 127.0.0.1:10443 -> 8443
Forwarding from [::1]:10443 -> 8443
```
![image](https://user-images.githubusercontent.com/99823951/224997923-04fe5bc8-46e5-4f20-9e45-7499e13921c4.png)

------
