resource "yandex_vpc_network" "netology-vpc" {
  name = var.vpc_name
}

module "k8s" {
  source = "./k8s"
  token = var.token
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  service_account_id = var.service_account_id
  netology_vpc_id = yandex_vpc_network.netology-vpc.id
  public_subnet = var.public_subnet
  public_key = local.public_key
}

module "gitlab" {
  source = "./gitlab"
  token = var.token
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  subnet_id = module.k8s.subnet
  public_key = local.public_key
}