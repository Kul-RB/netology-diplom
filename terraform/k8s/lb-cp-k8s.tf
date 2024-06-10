resource "yandex_compute_instance" "k8s_lb_cp" {

  name        = var.res_lb_cp.name
  hostname    = var.res_lb_cp.name
  platform_id = var.resources.platform
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

  zone = var.res_lb_cp.zone

  network_interface {
    subnet_id = yandex_vpc_subnet.public["${var.res_lb_cp.subnet}"].id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

}