# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.  
Deployment [создал](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/multitool.yaml) 
Ошибку удалось обойти только созданием `kubectl create configmap` и монтированием путей, что запрашивал multitool
в итоге повесил multitool на 80 порта, nginx на 81
Deployment успешно создается, replic-и успешно получается увеличивать.
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl describe pods multitool-9698bbc54-cztkd
Name:             multitool-9698bbc54-cztkd
Namespace:        default
Priority:         0
Service Account:  default
Node:             k8s/10.129.0.17
Start Time:       Sun, 02 Apr 2023 14:21:55 +0700
Labels:           app=multi
                  pod-template-hash=9698bbc54
Annotations:      cni.projectcalico.org/containerID: f8caa10fe7fe195dc494f04ea50d29af7fe83cab01c67188d693061e602c6a5b
                  cni.projectcalico.org/podIP: 10.1.77.40/32
                  cni.projectcalico.org/podIPs: 10.1.77.40/32
Status:           Running
IP:               10.1.77.40
IPs:
  IP:           10.1.77.40
Controlled By:  ReplicaSet/multitool-9698bbc54
Containers:
  multitool:
    Container ID:   containerd://2001cf06c52709ed1382bc011715720732cb4dd2c4e27dc15e32d6795d20b51e
    Image:          wbitt/network-multitool
    Image ID:       docker.io/wbitt/network-multitool@sha256:82a5ea955024390d6b438ce22ccc75c98b481bf00e57c13e9a9cc1458eb92652
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 02 Apr 2023 14:21:58 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /usr/share/nginx/html from config (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-c4pr6 (ro)
  nginx:
    Container ID:   containerd://a9c9e38acad36f5be899415fbf361c985465df5472d2a7bbd6550b492f84810e
    Image:          nginx:1.19
    Image ID:       docker.io/library/nginx@sha256:df13abe416e37eb3db4722840dd479b00ba193ac6606e7902331dcea50f4f1f2
    Port:           81/TCP
    Host Port:      0/TCP
```



2. После запуска увеличить количество реплик работающего приложения до 2.  

3. Продемонстрировать количество подов до и после масштабирования.  

```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f multitool.yaml
deployment.apps/multitool configured
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool                   1/1     Running   0          29m
multitool-9698bbc54-cztkd   2/2     Running   0          5s
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f multitool.yaml
deployment.apps/multitool configured
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool                   1/1     Running   0          28m
multitool-9698bbc54-cztkd   2/2     Running   0          25s
multitool-9698bbc54-2b74k   2/2     Running   0          11s
```

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.  
Создал сервис [svc](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/service_multitool.yaml)
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f service_multitool.yaml
service/svcmultitool created

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   9h
svcmultitool   ClusterIP   10.152.183.251   <none>        80/TCP    7s
```
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.  
Создал [pod](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/multitoolPod.yaml)
Получили хоть какой-то, но ответ. Вероятно ошибся где-то уже в часом конфиге nginx-a. Но `curl` отработал
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool                   1/1     Running   0          28m
multitool-9698bbc54-cztkd   2/2     Running   0          25s
multitool-9698bbc54-2b74k   2/2     Running   0          11s

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl 10.152.183.251
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.20.2</center>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   153  100   153    0     0   233k      0 --:--:-- --:--:-- --:--:--  149k
```
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.  
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.  
[Deployment](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/Deployment.yaml)
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get all
NAME            READY   STATUS    RESTARTS        AGE
pod/multitool   1/1     Running   1 (5m30s ago)   23m

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   8h
service/svcmultitool   ClusterIP   10.152.183.251   <none>        80/TCP    68m

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f Deployment.yaml
deployment.apps/nginx created
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                    READY   STATUS     RESTARTS      AGE
multitool               1/1     Running    1 (17m ago)   34m
nginx-d5c65877c-c556j   0/1     Init:0/1   0             5s
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                    READY   STATUS     RESTARTS      AGE
multitool               1/1     Running    1 (17m ago)   34m
nginx-d5c65877c-c556j   0/1     Init:0/1   0             8s
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                    READY   STATUS     RESTARTS      AGE
multitool               1/1     Running    1 (17m ago)   34m
nginx-d5c65877c-c556j   0/1     Init:0/1   0             10s

```


3. Создать и запустить Service. Убедиться, что Init запустился.  
[svc](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/service_nginx.yaml)  
4. Продемонстрировать состояние пода до и после запуска сервиса.  

```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f service_nginx.yaml
service/svcnginx created
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                    READY   STATUS            RESTARTS      AGE
multitool               1/1     Running           1 (17m ago)   35m
nginx-d5c65877c-c556j   0/1     PodInitializing   0             23s
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                    READY   STATUS    RESTARTS      AGE
multitool               1/1     Running   1 (17m ago)   35m
nginx-d5c65877c-c556j   1/1     Running   0             28s
```
Логи подтверждают, что было ожидание запуска службы  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl logs -f nginx-d5c65877c-c556j -c init
Server:    10.152.183.10
Address 1: 10.152.183.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'svcnginx.default.svc.cluster.local'
waiting for service
nslookup: can't resolve 'svcnginx.default.svc.cluster.local'
Server:    10.152.183.10
Address 1: 10.152.183.10 kube-dns.kube-system.svc.cluster.local

waiting for service
Server:    10.152.183.10
Address 1: 10.152.183.10 kube-dns.kube-system.svc.cluster.local

nslookup: can't resolve 'svcnginx.default.svc.cluster.local'
waiting for service
nslookup: can't resolve 'svcnginx.default.svc.cluster.local'
Server:    10.152.183.10
Address 1: 10.152.183.10 kube-dns.kube-system.svc.cluster.local

waiting for service
Server:    10.152.183.10
Address 1: 10.152.183.10 kube-dns.kube-system.svc.cluster.local

Name:      svcnginx.default.svc.cluster.local
Address 1: 10.152.183.151 svcnginx.default.svc.cluster.local

```

