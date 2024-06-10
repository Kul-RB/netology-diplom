resource "local_file" "hosts_cfg" {
    depends_on = [ yandex_compute_instance.k8s_cp, yandex_compute_instance.k8s_node ]
  content = templatefile("${path.module}/hosts.tftpl",

    { webservers = { 
        cp = yandex_compute_instance.k8s_cp,
        node  = yandex_compute_instance.k8s_node
        } } )

  filename = "/home/cfdata/dip/ansible/kubespray/inventory/k8s.netology.cluster/hosts.yaml"
}

resource "local_file" "all_cfg" {
  depends_on = [ yandex_compute_instance.k8s_lb_cp ]
  content = templatefile("${path.module}/all.tftpl",

   { webservers = { 
        lbcp = [yandex_compute_instance.k8s_lb_cp]
        } } )
  filename = "/home/cfdata/dip/ansible/kubespray/inventory/k8s.netology.cluster/group_vars/all/all.yml"
}

resource "local_file" "conf_lb_cfg" {
  depends_on = [ yandex_compute_instance.k8s_lb_cp ]
  content = templatefile("${path.module}/conf_lb.tftpl",

   { webservers = { 
        lbcp = [yandex_compute_instance.k8s_lb_cp]
        } } )
  filename = "/home/cfdata/dip/ansible/config_lb_cp/inventory/hosts.yaml"
}

resource "local_file" "vars_cfg" {
  depends_on = [ yandex_compute_instance.k8s_cp, yandex_compute_instance.k8s_lb_cp ]
  content = templatefile("${path.module}/vars.tftpl",

   { webservers = { 
        lbcp = [yandex_compute_instance.k8s_lb_cp],
        cp   = yandex_compute_instance.k8s_cp
        } } )
  filename = "/home/cfdata/dip/ansible/config_lb_cp/group_vars/lbcp/vars.yaml"
}

resource "null_resource" "local-exec" {
  depends_on = [ local_file.all_cfg, local_file.conf_lb_cfg, local_file.hosts_cfg, local_file.vars_cfg ]
  provisioner "local-exec" {
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i /home/cfdata/dip/ansible/config_lb_cp/inventory/hosts.yaml --become --become-user=root  /home/cfdata/dip/ansible/config_lb_cp/main.yaml"
    on_failure = continue 
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
    triggers = {  
      playbook_src_hash  = file("/home/cfdata/dip/ansible/config_lb_cp/main.yaml") 
      ssh_public_key     = var.public_key 
    }
}

