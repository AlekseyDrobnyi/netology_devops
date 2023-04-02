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
Ошибку исправил, переопределив порть для multitool-a на `1180` и `11443`  
Deployment успешно создается, replic-и успешно получается увеличивать.
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
multitool                    1/1     Running   0          5h34m
multitool-86b94869bc-xnbrf   2/2     Running   0          9s
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl logs -f multitool-86b94869bc-xnbrf -c nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl logs -f multitool-86b94869bc-xnbrf -c multitool
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - multitool-86b94869bc-xnbrf - 10.1.77.42 - HTTP: 1180 , HTTPS: 11443 . (Formerly praqma/network-multitool)
Replacing default HTTP port (80) with the value specified by the user - (HTTP_PORT: 1180).
Replacing default HTTPS port (443) with the value specified by the user - (HTTPS_PORT: 11443).

```



2. После запуска увеличить количество реплик работающего приложения до 2.  

3. Продемонстрировать количество подов до и после масштабирования.  

```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f multitool.yaml
deployment.apps/multitool configured
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool                   1/1     Running   0          5h34m
multitool-86b94869bc-xnbrf  2/2     Running   0          5s

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f multitool.yaml
deployment.apps/multitool configured
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
multitool                    1/1     Running   0          5h36m
multitool-86b94869bc-xnbrf   2/2     Running   0          2m35s
multitool-86b94869bc-v86qr   2/2     Running   0          6s

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
NAME                         READY   STATUS    RESTARTS   AGE
multitool                    1/1     Running   0          5h36m
multitool-86b94869bc-xnbrf   2/2     Running   0          2m35s
multitool-86b94869bc-v86qr   2/2     Running   0          6s


ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl 10.152.183.227
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   869k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
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

