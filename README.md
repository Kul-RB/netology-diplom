# Дипломный практикум в Yandex.Cloud Кулебякин Роман
 * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

### Задания
1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

### Решение
1. С помощью Terraform создал новый сервисный аккаунт с правилами для (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform_state_config/sa.tf)
    а. ObjectStorage (storage.editor) - для хранения state Terraform
    б. Compute (compute.admin) - для создания ВМ и управления ими
    в. KMS (kms.editor) - для шифрования ObjectStorage
    г. Resource Manager (resource-manager.editor) 
    д. VPC (vpc.admin) - для создания VPC
   Далее получил access_key и secret_key для работы с ObjectStorage
1.1 Создал bucket в YandexObjectStorage и включил шифрование (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform_state_config/s3.tf)

2. Подготовил backend для Terraform, инициализация с помощью terraform init -backend-config="access_key=$(cat .access_key)" -backend-config="secret_key=$(.secret_key)". Файлы .secret_key и .access_key сохранились при создании сервисного аккаунта и bucket (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/providers.tf)
3. Создал VPC, и 3 подсети в разных зонах (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/k8s/main.tf):
    а. subnet-a (ru-central1-a)
    б. subnet-b (ru-central1-b)
    в. subnet-d (ru-central1-d)

### Создание Kubernetes кластера

### Задание

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)

### Решение

Я выбрал рекомендуемый вариант установки K8s класетра с помощью Ansible
1.  При помощт Terraform установил 7 машин (3 control-plane (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/k8s/k8s-master.tf), 3 worer-node(на них распологается и etcd https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/k8s/k8s-nodes.tf), 1 LoadBalancer для Control-plane на основе Haproxy (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/k8s/lb-cp-k8s.tf)). Машины находятся в разных зонах:
![image](https://github.com/Kul-RB/netology-diplom/assets/53901269/bc210918-f230-4e64-bd6d-aa44a7034278)

![image](https://github.com/Kul-RB/netology-diplom/assets/53901269/94a815a7-09fc-42af-b83c-5b99ffc9e830)

2. Подготовил конфигурацию kubespray: host.yaml (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/ansible/kubespray/inventory/k8s.netology.cluster/hosts.yaml), all.yaml (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/ansible/kubespray/inventory/k8s.netology.cluster/group_vars/all/all.yml) заполнил с помощью Terraform Template
2.1 Также написал отдельный playbook (https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/ansible/config_lb_cp/main.yaml) для конфигурации LoadBalancer для Control-Plane, установка, настройка и запуск Haproxy (запуск данного Playbook выполнял с помощью Terraform local-exec)(https://github.com/Kul-RB/netology-diplom/blob/b11ca8edf1b591f4605e6b4bc9db36b705527966/terraform/k8s/ansible.tf) 

3. Запустил Playbook для установки K8s с помощью kubespray
3.1 После установки скопировал admin.conf на своб машину для доступа kubectl к кластеру
![image](https://github.com/Kul-RB/netology-diplom/assets/53901269/9c7208a8-f94c-4280-a555-b744e6fe9c5a)

### Создание тестового приложения

### Задание

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

### Решение

Я выбрал рекомендуемый вариант создал Dockerfile и статическую страницу которая выдает текст

1. https://kulnet.gitlab.yandexcloud.net/kul-rb/nginx_app - репозиторий в GitLab созданном в YC
2. https://hub.docker.com/repository/docker/dokcercc/nginx_app/general - ссылка образа на Dockerhub

### Подготовка cистемы мониторинга и деплой приложения

### Задание
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

### Решение
1. Для устaновки мониторинга для K8s Cluster использовал Helm Chart kube-prometheus-stack
   а. Ссылка для доступа к интерфейсу Grafana -  http://178.154.229.77:31101/

   б. Дашборды NodeExporter для каждого узла

![image](https://github.com/Kul-RB/netology-diplom/assets/53901269/ebc229ca-6599-40ed-a4b9-844e29a137b4)

   в. Ссылка на статичную страничку из тестового приложения - http://178.154.229.77:30598/
   
### Установка и настройка CI/CD

### Задание
1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

### Решение
1. Ссылка на Gitlab Pipeline - https://kulnet.gitlab.yandexcloud.net/kul-rb/nginx_app/-/pipelines
2. При любом коммите без тега в ветку master приолжение билдится и пушится в gitlab reposity, при установки тега (v1.0.0) приложение также билдится пушится в репозиторий и деплоится в K8s в лейблом тега 
https://kulnet.gitlab.yandexcloud.net/kul-rb/nginx_app/-/blob/da70909e5468853d938f0d6f9d732898ec9cc9f1/.gitlab-ci.yml

![image](https://github.com/Kul-RB/netology-diplom/assets/53901269/468e4e3a-2eda-413b-8975-07b94075e9fa)



