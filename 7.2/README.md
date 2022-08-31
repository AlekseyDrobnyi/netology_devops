# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются. 

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

Создал технический аккаунт
```Bash
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ yc iam service-account get sa-terraform
id: ajeg721h416vi7cag2bm
folder_id: b1g3oeejfshbl9k1707m
created_at: "2022-08-31T05:35:33Z"
name: sa-terraform

ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ yc iam service-account list --folder-id b1g3oeejfshbl9k1707m
+----------------------+--------------+
|          ID          |     NAME     |
+----------------------+--------------+
| ajeg721h416vi7cag2bm | sa-terraform |
+----------------------+--------------+


```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

[main.tf](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/7.2/etc/main.tf)
[version.tf](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/7.2/etc/version.tf)
 
---
Регистрируем провайдер
```bash
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.77.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Запускам применение нашей конфигурации
```bash
buntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1 will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      
.....................................................................

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_vm_1 = "84.201.158.27"
internal_ip_address_vm_1 = "192.168.10.18"

```

Удаляем конфигурацию из облака Яндекс.
```bash
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform destroy -auto-approve
yandex_vpc_network.network-1: Refreshing state... [id=enpqihq02v6nm70pp1u6]
yandex_vpc_subnet.subnet-1: Refreshing state... [id=e9b9v85iarqjfcuujham]
yandex_compute_instance.vm-1: Refreshing state... [id=fhmatl4q2elm2n5jl6t8]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy
  
...........................................

Destroy complete! Resources: 3 destroyed.
```
