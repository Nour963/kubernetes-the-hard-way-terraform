#______________WORKER____________________________

resource "null_resource" "kubcnf-workers" {

  count = var.Mcount

  depends_on = [
    local_file.kube_proxy,
    local_file.kube_wrk,
    aws_lb.k8s-LB,
    
  ]

  connection {
    type          = "ssh"
    user          = var.user
    password     = var.password
    host          = "${aws_instance.k8s-WRKR[count.index].public_ip}"
    private_key   = "${file("./key/k8shardkey.pem")}"
   
  }

  provisioner "file" {
    source      = "./kubeconf/worker-${count.index+1}.kubeconfig"
    destination = "~/worker-${count.index+1}.kubeconfig"
  }

  provisioner "file" {
    source      = "./kubeconf/kube-proxy.kubeconfig"
    destination = "~/kube-proxy.kubeconfig"
  }
}

#___________________MASTERS______________________________

resource "null_resource" "kubcnf-masters" {
  count = var.Wcount

  depends_on = [
    local_file.kube_ctrl,
    local_file.kube_admin,
    local_file.kube_sch,
    
  ]

  connection {
    type          = "ssh"
    user          = var.user
    password     = var.password
    host          = "${aws_instance.k8s-MSTR[count.index].public_ip}"
    private_key   = "${file("./key/k8shardkey.pem")}"
   
  }

  
  provisioner "file" {
    source      = "./kubeconf/kube-scheduler.kubeconfig"
    destination = "~/kube-scheduler.kubeconfig"
  }
  provisioner "file" {
    source      = "./kubeconf/admin.kubeconfig"
    destination = "~/admin.kubeconfig"
  }
  provisioner "file" {
    source      = "./kubeconf/kube-controller-manager.kubeconfig"
    destination = "~/kube-controller-manager.kubeconfig"
  }

}
