# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.  
[Deployment](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.4/yml/multitool.yaml)
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.  
[Service](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.4/yml/service_multitool.yaml)  
Поднял 3 реплики приложения с nginx и multitool.  
Добавил в Service значения `port` и `targetPort` для перенаправления трафика по портам.  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f service_multitool.yaml
service/svcmulti configured

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get all -o wide
NAME                             READY   STATUS    RESTARTS   AGE     IP           NODE   NOMINATED NODE   READINESS GATES
pod/multitool                    1/1     Running   0          6h30m   10.1.77.30   k8s    <none>           <none>
pod/multitool-698ddd57df-8v78q   2/2     Running   0          32m     10.1.77.45   k8s    <none>           <none>
pod/multitool-698ddd57df-sxkhh   2/2     Running   0          32m     10.1.77.46   k8s    <none>           <none>
pod/multitool-698ddd57df-jb2lk   2/2     Running   0          32m     10.1.77.47   k8s    <none>           <none>

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE     SELECTOR
service/kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             25h     <none>
service/svcmulti     ClusterIP   10.152.183.227   <none>        9001/TCP,9002/TCP   6h30m   app=multi

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS        IMAGES                               SELECTOR
deployment.apps/multitool   3/3     3            3           56m   multitool,nginx   wbitt/network-multitool,nginx:1.19   app=multi

NAME                                   DESIRED   CURRENT   READY   AGE   CONTAINERS        IMAGES                               SELECTOR
replicaset.apps/multitool-698ddd57df   3         3         3       32m   multitool,nginx   wbitt/network-multitool,nginx:1.19   app=multi,pod-template-hash=698ddd57df
replicaset.apps/multitool-86b94869bc   0         0         0       56m   multitool,nginx   wbitt/network-multitool,nginx:1.19   app=multi,pod-template-hash=86b94869bc
```
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.  
[Pod](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.3/yml/multitoolPod.yaml)
Использую ранее созданный с multitool из предыдущих заданий.  
Проверяю `curl` доступность портов.  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl 10.152.183.227:9001
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
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  1025k      0 --:--:-- --:--:-- --:--:--  597k


ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl 10.152.183.227:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - multitool-698ddd57df-sxkhh - 10.1.77.46 - HTTP: 8080 , HTTPS: 11443 . (Formerly praqma/network-multitool)
100   145  100   145    0     0  13680      0 --:--:-- --:--:-- --:--:-- 14500
```
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.  
Тоже самое произвожу, но уже по DNS имени Servic-a
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl svcmulti.default.svc.cluster.local:9001
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   289k      0 --:--:-- --:--:-- --:--:--  597k
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
................

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec multitool -- curl svcmulti.default.svc.cluster.local:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   145  100   145    0     0  76923      0 --:--:-- --:--:-- --:--:--  141k
WBITT Network MultiTool (with NGINX) - multitool-698ddd57df-jb2lk - 10.1.77.47 - HTTP: 8080 , HTTPS: 11443 . (Formerly praqma/network-multitool)
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.  
[External_service](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.4/yml/external_service.yaml)  
Service создал, указал в нем `nodePort` 32180 для nginx  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f external_service.yaml
service/externalsvc created

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get svc
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
kubernetes    ClusterIP   10.152.183.1     <none>        443/TCP                         26h
svcmulti      ClusterIP   10.152.183.227   <none>        9001/TCP,9002/TCP               6h46m
externalsvc   NodePort    10.152.183.140   <none>        9001:32180/TCP,9002:30071/TCP   90s
```
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.  
![image](https://user-images.githubusercontent.com/99823951/229356847-6fb282e4-1d72-47c8-923c-14c0beecccf2.png)

![image](https://user-images.githubusercontent.com/99823951/229356865-2663263d-9157-40c0-8ca2-81bef0965444.png)

![image](https://user-images.githubusercontent.com/99823951/229357542-a25aa5cf-607f-4781-986b-81be474e8aa7.png)

3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
