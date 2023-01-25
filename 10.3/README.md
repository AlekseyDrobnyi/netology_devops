# Домашнее задание к занятию "10.03. Grafana"
### Задание 1  
## Задание повышенной сложности  

Не используйте директорию [help](https://github.com/AlekseyDrobnyi/netology_devops/tree/main/10.3/help) для сборки проекта, самостоятельно разверните grafana, где в 
роли источника данных будет выступать prometheus, а сборщиком данных node-exporter:
- grafana  
```
ubuntu@ubuntu-VirtualBox:~$ sudo wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.3.2_amd64.deb  
ubuntu@ubuntu-VirtualBox:~$ sudo apt install ./grafana-enterprise_9.3.2_amd64.deb  
Reading package lists... Done 
``` 
скачиваем deb пакет Grafan-ы, устанавливаем его. Запускаем сервис.

```ubuntu@ubuntu-VirtualBox:~$ sudo systemctl start grafana-server  
ubuntu@ubuntu-VirtualBox:~$ sudo systemctl status grafana-server  
● grafana-server.service - Grafana instance  
Loaded: loaded (/lib/systemd/system/grafana-server.service; disabled; vendor preset: enabled)  
Active: active (running) since Mon 2023-01-23 12:33:46 +07; 7s ago```
Docs: http://docs.grafana.org  
ubuntu@ubuntu-VirtualBox:~$ sudo systemctl enable grafana-server
```

![image](https://user-images.githubusercontent.com/99823951/213972209-6070ad5a-f80e-4c9e-803e-cb8840272eb7.png)

- prometheus-server
Скачиваем архив prometheus, разворачиваем его, создаем и распределяем по дерикториям.
```
ubuntu@ubuntu-VirtualBox:~$ wget https://github.com/prometheus/prometheus/releases/download/v2.37.5/prometheus-2.37.5.linux-amd64.tar.gz  
ubuntu@ubuntu-VirtualBox:~$ sudo mkdir /etc/prometheus  
ubuntu@ubuntu-VirtualBox:~$ sudo mkdir /var/lib/prometheus  
ubuntu@ubuntu-VirtualBox:~$ tar zxvf prometheus-*.linux-amd64.tar.gz  
ubuntu@ubuntu-VirtualBox:~$ cd prometheus-*.linux-amd64  
ubuntu@ubuntu-VirtualBox:~$ cp prometheus promtool /usr/local/bin/  
ubuntu@ubuntu-VirtualBox:~$ cp -r console_libraries consoles prometheus.yml /etc/prometheus  
```
Создаем пользователя, меняем владельца директорий 
```
ubuntu@ubuntu-VirtualBox:~/prometheus-2.37.5.linux-amd64$ sudo useradd --no-create-home --shell /bin/false prometheus  
ubuntu@ubuntu-VirtualBox:~$ sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus  
ubuntu@ubuntu-VirtualBox:~$ sudo chown -R prometheus:prometheus /usr/local/bin/{prometheus, promtool}  
```
создали демона, запускающего Prometheus при старте хоста.
```
ubuntu@ubuntu-VirtualBox:~$ cat /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target
```
Запускаем, проверяем работу prometheus
```
ubuntu@ubuntu-VirtualBox:~$ systemctl daemon-reload
ubuntu@ubuntu-VirtualBox:~$ systemctl enable prometheus
ubuntu@ubuntu-VirtualBox:~$ systemctl start prometheus
ubuntu@ubuntu-VirtualBox:~$ systemctl status prometheus
● prometheus.service - Prometheus
Loaded: loaded (/etc/systemd/system/prometheus.service; enabled; vendor preset: enabled)
Active: active (running) since Sun 2023-01-22 18:51:40 +07; 6s ago
Main PID: 3796 (prometheus)
Tasks: 6 (limit: 4618)
Memory: 15.6M
CGroup: /system.slice/prometheus.service
└─3796 /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storag>
```

![image](https://user-images.githubusercontent.com/99823951/213914539-3d24eeb1-22a0-4f23-942d-76f1ca965068.png)



- prometheus node-exporter  
Практически по аналогии делаем и с Node-exporter. Не забывая в конце, поправить конфиги Prometheus
```
ubuntu@ubuntu-VirtualBox:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz  
ubuntu@ubuntu-VirtualBox:~$ tar zxvf node_exporter-*.linux-amd64.tar.gz  
ubuntu@ubuntu-VirtualBox:~$ cd node_exporter-*.linux-amd64  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ sudo cp node_exporter /usr/local/bin  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ sudo useradd --no-create-home --shell /bin/false nodeusr  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ sudo chown -R nodeusr:nodeusr /usr/local/bin/node_exporter  
```
```
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter Service
After=network.target
[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
[Install]
WantedBy=multi-user.target
```
```
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ systemctl daemon-reload  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ systemctl enable node_exporter  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ systemctl start node_exporter  
ubuntu@ubuntu-VirtualBox:~/node_exporter-1.5.0.linux-amd64$ systemctl status node_exporter  
● node_exporter.service - Node Exporter Service
Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset:>
Active: active (running) since Sun 2023-01-22 19:05:57 +07; 3min 33s ago
```
добавляем в конфиг prometheus - указатель на node_exporter для сбора метрик
```
ubuntu@ubuntu-VirtualBox:~$ cat /etc/prometheus/prometheus.yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).
 
# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093
 
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"
 
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"
 
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
 
    static_configs:
      - targets: ["localhost:9090","localhost:9100"]
```
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
```node_filesystem_avail_bytes {fstype=~"ext4|xfs"}```
```node_filesystem_size_bytes {fstype=~"ext4|xfs"}```


Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.
![image](https://user-images.githubusercontent.com/99823951/213990800-8e70dd6e-a3f1-439a-96f2-4ebcc550ff8c.png)



## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.
![image](https://user-images.githubusercontent.com/99823951/214041830-19aa65fc-9ce3-4580-a8fd-19b0a8816574.png)


## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
```
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 3,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 2,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "100 - (avg by (instance)(rate(node_cpu_seconds_total{job=\"prometheus\", mode=\"idle\"}[5m]))*100)",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "CPU load",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "series",
            "axisLabel": "",
            "axisPlacement": "left",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "max": 3,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 4,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "asc"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "node_load1{job=\"prometheus\"}",
          "instant": false,
          "legendFormat": "1 min",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "node_load5{job=\"prometheus\"}",
          "hide": false,
          "legendFormat": "5 min",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "node_load15{job=\"prometheus\"}",
          "hide": false,
          "legendFormat": "15 min",
          "range": true,
          "refId": "C"
        }
      ],
      "title": "CPULA 1/5/15",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 0,
        "y": 9
      },
      "id": 6,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "node_memory_MemFree_bytes / (1024 * 1024)",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Panel Title",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 6,
        "y": 9
      },
      "id": 8,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "(node_memory_MemFree_bytes / node_memory_MemTotal_bytes) * 100",
          "legendFormat": "__auto",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "MemFree %",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "GB",
            "axisPlacement": "left",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 12,
        "y": 9
      },
      "id": 10,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "none",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "exemplar": false,
          "expr": "node_filesystem_avail_bytes {fstype=~\"ext4|xfs\"} / (1024 * 1024 * 1024)",
          "legendFormat": "Free Disk",
          "range": true,
          "refId": "Free disk"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "node_filesystem_size_bytes{fstype=~\"ext4|xfs\"} / (1024 * 1024 * 1024)",
          "hide": false,
          "legendFormat": "Total Disk",
          "range": true,
          "refId": "Total Disk"
        }
      ],
      "title": "Disk",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "L5RtOJoVk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "series",
            "axisLabel": "GB",
            "axisPlacement": "left",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 18,
        "y": 9
      },
      "id": 12,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "L5RtOJoVk"
          },
          "editorMode": "code",
          "expr": "node_filesystem_free_bytes{job=\"prometheus\",mountpoint=\"/\"} / (1024*1024*1024)",
          "legendFormat": "Free disk",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "Disk Free",
      "type": "timeseries"
    }
  ],
  "refresh": false,
  "schemaVersion": 37,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "My_first_dashboard",
  "uid": "vQ72TJoVk",
  "version": 19,
  "weekStart": ""
}

```

В решении задания - приведите листинг этого файла.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
