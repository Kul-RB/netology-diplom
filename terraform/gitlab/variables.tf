variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "public_key" {
  type        = string
  description = "SSH public key"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}

variable "gitlab" {
  type = list(object({
    name          = string
    platform      = string
    cores         = number
    memory        = number
    core_fraction = number
    image_id      = string
    type          = string
    size          = number
    zone          = string
    subnet        = string
    nat           = bool
  }))
  default = [{
    name          = "gitlab-runner"
    platform      = "standard-v3"
    cores         = 2
    memory        = 4
    core_fraction = 20
    image_id      = "fd84rmelvcpjp2jpo1gq"
    type          = "network-hdd"
    size          = 30
    zone          = "ru-central1-a"
    subnet        = "subnet-a"
    nat           = true
  }]
  description = "Configure Gitlab node"
}