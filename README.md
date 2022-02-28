# netology_devops
netology_devopdad
будут игнорироваться все файлы в подкаталоге  .terraform
**/.terraform/*

будут исключаться из commita файлы с расширениями tfstate
*.tfstate
*.tfstate.*

игнорировать файлы логов с названием crash.log
crash.log
crash.*.log

тут будут игнорироваться все файлы с такими расширениями .tfvars
*.tfvars
*.tfvars.json

исключать файлы с назварием и расширениями override., а так же все файлы, которые заканчиваются на _override.
override.tf
override.tf.json
*_override.tf
*_override.tf.json

игнорировать файлы конфигурации CLI
.terraformrc
terraform.rc


update reamde.md

NEW_LINE_DZ3
