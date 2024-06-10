resource "yandex_vpc_subnet" "public"{
  for_each = { for res in var.public_subnet: res.name=>res }
  name           = each.key
  v4_cidr_blocks = each.value.default_cidr_public
  zone           = each.value.zone
  network_id     = var.netology_vpc_id
}