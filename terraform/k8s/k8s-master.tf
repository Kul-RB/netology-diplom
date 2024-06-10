resource "yandex_compute_instance" "k8s_cp" {
  depends_on = [ yandex_vpc_subnet.public ]

  for_each = { for res in var.name_cp: res.name=>res }

  name        = each.key
  hostname    = each.key
  platform_id = each.value.platform
  resources {
    cores         = var.resources.cores 
    memory        = var.resources.memory
    core_fraction = var.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.boot_disk.image_template
      type     = var.boot_disk.type
      size     = var.boot_disk.size
    }
  }
  scheduling_policy {
    preemptible = false
  }

  zone = each.value.zone

  network_interface {
    subnet_id = yandex_vpc_subnet.public["${each.value.subnet}"].id
    nat       = true
  }
  
  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

}

