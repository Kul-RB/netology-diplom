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

variable "security_group_id" {
  type        = string
  description = "Id security group"
}

variable "service_account_id" {
  type        = string
  description = "Id security group"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "netology-vpc"
  description = "VPC name"
}

variable "public_subnet" {
  type = list(object({
    name = string
    default_cidr_public = list(string)
    zone = string
  }))
  default = [ {
    name = "subnet-a"
    default_cidr_public = ["192.168.20.0/24"]
    zone = "ru-central1-a"
  },
  {
    name = "subnet-b"
    default_cidr_public = ["192.168.21.0/24"]
    zone = "ru-central1-b"
  },
  {
    name = "subnet-d"
    default_cidr_public = ["192.168.22.0/24"]
    zone = "ru-central1-d"
  } ]
}