# Домашнее задание к занятию "10.03. Grafana"
### Задание 1  
## Задание повышенной сложности  

Не используйте директорию [help](https://github.com/AlekseyDrobnyi/netology_devops/tree/main/10.3/help) для сборки проекта, самостоятельно разверните grafana, где в 
роли источника данных будет выступать prometheus, а сборщиком данных node-exporter:
- grafana  

![image](https://user-images.githubusercontent.com/99823951/213972209-6070ad5a-f80e-4c9e-803e-cb8840272eb7.png)

- prometheus-server
![image](https://user-images.githubusercontent.com/99823951/213914539-3d24eeb1-22a0-4f23-942d-76f1ca965068.png)


- prometheus node-exporter  
![image](https://user-images.githubusercontent.com/99823951/213914910-1b97a62e-e8a7-420f-8e59-0ec424bc85c1.png)

![image](https://user-images.githubusercontent.com/99823951/213915160-2a6931ac-110f-4087-8222-9b54ed04374e.png)


Зайдите в веб-интерфейс графана, используя авторизационные данные.

Подключите поднятый вами prometheus как источник данных.  
![image](https://user-images.githubusercontent.com/99823951/213973675-f63b1275-074e-4457-96f1-1a61fa90e63b.png)


Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

## Задание 2
Изучите самостоятельно ресурсы:
- [PromQL query to find CPU and memory](https://stackoverflow.com/questions/62770744/promql-query-to-find-cpu-and-memory-used-for-the-last-week)
- [PromQL tutorial](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085)
- [Understanding Prometheus CPU metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)  
````100 - (avg by (instance)(rate(node_cpu_seconds_total{job="prometheus",mode="idle"}[5m])) * 100)````
- CPULA 1/5/15  
```node_load1{job="prometheus"}```   
```node_load5{job="prometheus"}```   
```node_load15{job="prometheus"}```  
- Количество свободной оперативной памяти  
```node_memory_MemFree_bytes{job="prometheus"}```  
```node_memory_MemFree_bytes / node_memory_Memtotal_bytes) * 100``` 
- Количество места на файловой системе  
```node_filesystem_free_bytes{job="prometheus",mountpoint="/"}```  
```node_filesystem_avail_bytes {fstype=~"ext4|xfs"}``````node_filesystem_size_bytes {fstype=~"ext4|xfs"}```


Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.
![image](https://user-images.githubusercontent.com/99823951/213990800-8e70dd6e-a3f1-439a-96f2-4ebcc550ff8c.png)



## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
