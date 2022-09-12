terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "drobniy-netology"
    region     = "ru-central1"
    key        = "s3/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}