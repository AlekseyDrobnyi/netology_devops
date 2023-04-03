# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.  
[Создал](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.5/yml/nginxDep.yaml)
2. Создать Deployment приложения _backend_ из образа multitool.   
[Создал](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.5/yml/multitoolDep.yaml)
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f nginxDep.yaml
deployment.apps/nginx created

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f multitoolDep.yaml
deployment.apps/multitool created

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods
NAME                       READY   STATUS    RESTARTS   AGE
frontend-6879454b8-8cc4l   1/1     Running   0          5m22s
frontend-6879454b8-rgn4z   1/1     Running   0          5m22s
frontend-6879454b8-dqmgg   1/1     Running   0          5m22s
backend-66d67bc84b-ww66l   1/1     Running   0          40s
```

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.   
[Service Frontend](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.5/yml/svcFront.yaml)  
[Service Backend](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.5/yml/svcBack.yaml)
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f svcBack.yaml
service/svcback created
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f svcFront.yaml
service/svcfront created


ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pod -o wide --show-labels
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE   NOMINATED NODE   READINESS GATES   LABELS
frontend-6879454b8-8cc4l   1/1     Running   0          31m   10.1.77.60   k8s    <none>           <none>            app=front,pod-template-hash=6879454b8
frontend-6879454b8-rgn4z   1/1     Running   0          31m   10.1.77.61   k8s    <none>           <none>            app=front,pod-template-hash=6879454b8
frontend-6879454b8-dqmgg   1/1     Running   0          31m   10.1.77.62   k8s    <none>           <none>            app=front,pod-template-hash=6879454b8
backend-649d976d64-6tcqq   1/1     Running   0          19m   10.1.77.2    k8s    <none>           <none>            app=back,pod-template-hash=649d976d64

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get svc -o wide 
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE   SELECTOR
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP    32h   <none>
svcback      ClusterIP   10.152.183.146   <none>        1180/TCP   17m   app=back
svcfront     ClusterIP   10.152.183.226   <none>        8080/TCP   17m   app=front

```
4. Продемонстрировать, что приложения видят друг друга с помощью Service.  
Pod-ы успешно отправляют друг другу запросы через порты.  
```bash

ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec backend-649d976d64-6tcqq -- curl svcfront:8080
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
100   612  100   612    0     0   536k      0 --:--:-- --:--:-- --:--:--  597k


ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl exec frontend-6879454b8-rgn4z -- curl svcback:1180
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   142  100   142    0     0   4733      0 --:--:-- --:--:-- --:--:--  4896
WBITT Network MultiTool (with NGINX) - backend-649d976d64-6tcqq - 10.1.77.2 - HTTP: 8080 , HTTPS: 11443 . (Formerly praqma/network-multitool)
```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.  
```bash
ubuntu@k8s:~$ sudo microk8s enable ingress
Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enabled
```
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.  

Создал [Ingress](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/12.5/yml/ingress.yaml)  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/myingress created
```

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.  
![image](https://user-images.githubusercontent.com/99823951/229560677-b0f07650-818e-4bed-860c-0318c0cf213f.png)  

![image](https://user-images.githubusercontent.com/99823951/229560760-9e494eb7-f85d-4de3-b07a-fe288d611ac1.png)  

т.к. я использую в Deployment-e Nginx 1.19 версии. И при обращении на `/api` мне отвечает 1.20.2 - считаю, что это ответ получил от multitool, т.к. там конфиг вроде как не настроен/примонтирован.

```
C:\Users\79235>curl 158.160.14.41
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

C:\Users\79235>curl 158.160.14.41/api
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.20.2</center>
</body>
</html>
```

4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
