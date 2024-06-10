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

variable "service_account_id" {
  type        = string
  description = "Id security group"
}

variable "netology_vpc_id" {
  type = string
  description = "Id VPC"
}

variable "public_subnet" {
  type = list(object({
    name                = string
    default_cidr_public = list(string)
    zone                = string
  }))
  description = "Configuration subnet at different zone"
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

variable "zone_a" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_d" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnet_public" {
  type        = string
  default     = "public"
  description = "Subnet name"
}

variable "k8s_ig_cp" {
  type        = string
  default     = "kubernetes-cp"
  description = "Instance group kubernetes controle plane"
}

variable "name_nodes" {
  type        = list(object({
    name      = string
    subnet    = string
    platform  = string
    zone      = string
  }))
  default     = [{
    name     = "node1",
    subnet   = "subnet-a",
    platform = "standard-v3",
    zone     = "ru-central1-a"
  },{
    name     = "node2",
    subnet   = "subnet-b",
    platform = "standard-v3",
    zone     = "ru-central1-b"
  },{
    name     = "node3",
    subnet   = "subnet-d",
    platform = "standard-v3",
    zone     = "ru-central1-d"
  }]
  description = "Instance group kubernetes node"
}

variable "name_cp" {
  type        = list(object({
    name      = string
    subnet    = string
    platform  = string
    zone      = string
  }))
  default     = [{
    name     = "cp1",
    subnet   = "subnet-a",
    platform = "standard-v3",
    zone     = "ru-central1-a"
  }
  ,{
    name     = "cp2",
    subnet   = "subnet-b",
    platform = "standard-v3",
    zone     = "ru-central1-b"
  },{
    name     = "cp3",
    subnet   = "subnet-d",
    platform = "standard-v3",
    zone     = "ru-central1-d"
  }
  ]
  description = "Instance group kubernetes node"
}

variable "resources" {
  type = object({
    platform      = string
    memory        = number
    cores         = number
    core_fraction = number 
  })
  default = {
    platform      = "standard-v3"
    memory        = 4
    cores         = 2
    core_fraction = 20
  }
  description = "Resources for nodes"
}

variable "boot_disk" {
  type = object({
    mode           = string
    image_template = string
    type           = string
    size           = number
  })
  default = {
    mode           = "READ_WRITE"
    image_template = "fd84rmelvcpjp2jpo1gq"
    type           = "network-ssd"
    size           = 30
  }
  description = "Boot disk"
}

variable "policy_master" {
  type = object({
    scale_policy    = number
    max_unavailable = number
    max_expansion   = number
  })
  default = {
    scale_policy    = 3
    max_expansion   = 1
    max_unavailable = 1
  }
}

variable "res_lb_cp" {
  type = object({
    name          = string
    zone          = string
    subnet        = string
  })
  default = {
    name          = "lbcp"
    zone          = "ru-central1-a"
    subnet        = "subnet-a"
  }
  description = "Resources fo loadbalancer controle plane"
}