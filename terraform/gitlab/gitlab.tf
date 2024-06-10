resource "yandex_compute_instance" "gitlab" {

  for_each = { for res in var.gitlab: res.name=>res }
  name        = each.key
  hostname    = each.key
  platform_id = each.value.platform
  resources {
    cores         = each.value.cores 
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = each.value.image_id
      type     = each.value.type
      size     = each.value.size
    }
  }
  scheduling_policy {
    preemptible = false
  }
  allow_stopping_for_update = true
  zone = each.value.zone

  network_interface {
    subnet_id = var.subnet_id
    nat       = each.value.nat
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

}