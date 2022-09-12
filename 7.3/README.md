# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).
![image](https://user-images.githubusercontent.com/99823951/189614867-90681da5-d2c6-4b26-9b6d-9dd69f0f5e08.png)

## Задача 2. Инициализируем проект и создаем воркспейсы.  
1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
```
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform init -backend-config=keys.s3.tfbackend

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.75.0...
- Installed yandex-cloud/yandex v0.75.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

![image](https://user-images.githubusercontent.com/99823951/189624039-1f868c3e-7573-4613-b2d2-e945c1d870e2.png)


2. Создайте два воркспейса `stage` и `prod`.
```
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

```
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform workspace list
  default
* prod
  stage
```
```
ubuntu@ubuntu-VirtualBox:~/cloud-terraform$ terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1-count[0] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKY6dcArL/o21FUqUpX2a8IAMZet/1PCwVdA3tNFH/T+Q29zidYIdJ/KLamX09IdnsW6WDx2fIcSVrlD3ZHjy7HyszL6QTf2i0O3P1aCOPWKzSmJc7QBWTyjcrIqmotnRW62DJxp3hYShCyI6emoX8azo3Y5f2sdThsTLTb1N7ZJg+Bupz/V87MLBI0uhRjR187XbM9qa8c/BAq+kZSLwjecLBXDtLx3VMRSKv2oEGWCdlF3gJjm7OGm4eDraxsFbs0YR8RoQrPFA868G8aHcOX+c1DglkwJLgtMjyKYIThPJkR3FGclYvGiXDa8gLvGLC0wN9p/AfzzvV7n8rphJSdN+hWLvUusfv/bC8+R7NUm2nimG6berBI/SidOQ0qdepC94X7tsmuYB9mqwmmSHCWQa2QvXKfCbz3IxXBaiaFcTeKod/h941giLrNGGsZtxt1IHPiQr22IAWN3bGSILOot5dKDAvM5djQ6VZq1XpdOQCE5dNJo1gEf8211M6y4c= vagrant@ubuntu-20
            EOT
        }
      + name                      = "prod-count-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89ovh4ticpo40dkbvd"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-count[1] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKY6dcArL/o21FUqUpX2a8IAMZet/1PCwVdA3tNFH/T+Q29zidYIdJ/KLamX09IdnsW6WDx2fIcSVrlD3ZHjy7HyszL6QTf2i0O3P1aCOPWKzSmJc7QBWTyjcrIqmotnRW62DJxp3hYShCyI6emoX8azo3Y5f2sdThsTLTb1N7ZJg+Bupz/V87MLBI0uhRjR187XbM9qa8c/BAq+kZSLwjecLBXDtLx3VMRSKv2oEGWCdlF3gJjm7OGm4eDraxsFbs0YR8RoQrPFA868G8aHcOX+c1DglkwJLgtMjyKYIThPJkR3FGclYvGiXDa8gLvGLC0wN9p/AfzzvV7n8rphJSdN+hWLvUusfv/bC8+R7NUm2nimG6berBI/SidOQ0qdepC94X7tsmuYB9mqwmmSHCWQa2QvXKfCbz3IxXBaiaFcTeKod/h941giLrNGGsZtxt1IHPiQr22IAWN3bGSILOot5dKDAvM5djQ6VZq1XpdOQCE5dNJo1gEf8211M6y4c= vagrant@ubuntu-20
            EOT
        }
      + name                      = "prod-count-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89ovh4ticpo40dkbvd"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["2"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKY6dcArL/o21FUqUpX2a8IAMZet/1PCwVdA3tNFH/T+Q29zidYIdJ/KLamX09IdnsW6WDx2fIcSVrlD3ZHjy7HyszL6QTf2i0O3P1aCOPWKzSmJc7QBWTyjcrIqmotnRW62DJxp3hYShCyI6emoX8azo3Y5f2sdThsTLTb1N7ZJg+Bupz/V87MLBI0uhRjR187XbM9qa8c/BAq+kZSLwjecLBXDtLx3VMRSKv2oEGWCdlF3gJjm7OGm4eDraxsFbs0YR8RoQrPFA868G8aHcOX+c1DglkwJLgtMjyKYIThPJkR3FGclYvGiXDa8gLvGLC0wN9p/AfzzvV7n8rphJSdN+hWLvUusfv/bC8+R7NUm2nimG6berBI/SidOQ0qdepC94X7tsmuYB9mqwmmSHCWQa2QvXKfCbz3IxXBaiaFcTeKod/h941giLrNGGsZtxt1IHPiQr22IAWN3bGSILOot5dKDAvM5djQ6VZq1XpdOQCE5dNJo1gEf8211M6y4c= vagrant@ubuntu-20
            EOT
        }
      + name                      = "prod-foreach-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89ovh4ticpo40dkbvd"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["3"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKY6dcArL/o21FUqUpX2a8IAMZet/1PCwVdA3tNFH/T+Q29zidYIdJ/KLamX09IdnsW6WDx2fIcSVrlD3ZHjy7HyszL6QTf2i0O3P1aCOPWKzSmJc7QBWTyjcrIqmotnRW62DJxp3hYShCyI6emoX8azo3Y5f2sdThsTLTb1N7ZJg+Bupz/V87MLBI0uhRjR187XbM9qa8c/BAq+kZSLwjecLBXDtLx3VMRSKv2oEGWCdlF3gJjm7OGm4eDraxsFbs0YR8RoQrPFA868G8aHcOX+c1DglkwJLgtMjyKYIThPJkR3FGclYvGiXDa8gLvGLC0wN9p/AfzzvV7n8rphJSdN+hWLvUusfv/bC8+R7NUm2nimG6berBI/SidOQ0qdepC94X7tsmuYB9mqwmmSHCWQa2QvXKfCbz3IxXBaiaFcTeKod/h941giLrNGGsZtxt1IHPiQr22IAWN3bGSILOot5dKDAvM5djQ6VZq1XpdOQCE5dNJo1gEf8211M6y4c= vagrant@ubuntu-20
            EOT
        }
      + name                      = "prod-foreach-3"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd89ovh4ticpo40dkbvd"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_vm_1 = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_vm_1 = [
      + (known after apply),
      + (known after apply),
    ]
yandex_vpc_network.network-1: Creating...
yandex_vpc_network.network-1: Creation complete after 1s [id=enpd86re9mcthq6vrc8k]
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9b1he66tp886du5qujm]
yandex_compute_instance.vm-1-count[1]: Creating...
yandex_compute_instance.vm-1-count[0]: Creating...
yandex_compute_instance.vm-1-fe["2"]: Creating...
yandex_compute_instance.vm-1-fe["3"]: Creating...
yandex_compute_instance.vm-1-count[1]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-count[0]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-fe["2"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-count[1]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-count[0]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-fe["2"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-count[1]: Creation complete after 25s [id=fhmtnegg1ogtltq6bvbq]
yandex_compute_instance.vm-1-fe["3"]: Creation complete after 25s [id=fhmc57r3l56k1mqcb92t]
yandex_compute_instance.vm-1-fe["2"]: Creation complete after 25s [id=fhm6ada72dsr12bfrpp1]
yandex_compute_instance.vm-1-count[0]: Creation complete after 26s [id=fhm98jej35l3q86ufvsf]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_vm_1 = [
  "51.250.7.180",
  "51.250.5.6",
]
internal_ip_address_vm_1 = [
  "192.168.10.27",
  "192.168.10.22",
]
```
![image](https://user-images.githubusercontent.com/99823951/189623381-2b131fe0-902e-4a7d-939e-42219fb0ea38.png)

[файл main.tf](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/7.3/src/main.tf)  
[файл s3.tf](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/7.3/src/s3.tf)  
[файл version.tf](https://github.com/AlekseyDrobnyi/netology_devops/blob/main/7.3/src/version.tf)  
