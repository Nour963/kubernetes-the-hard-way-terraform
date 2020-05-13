

resource "null_resource" "ca-workers" {

  count = var.Wcount

  depends_on = [
    local_file.kubelet_crt,
    local_file.kubelet_key,
    local_file.kube_ca_key,
  ]

  connection {
    type          = "ssh"
    user          = var.user
    password     = var.password
    host          = "${aws_instance.k8s-WRKR[count.index].public_ip}"
    private_key   = "${file("./key/k8shardkey.pem")}"
   
  }

  provisioner "file" {
    source      = "./certificate/kubelet/worker-${count.index+1}.pem"
    destination = "~/worker-${count.index+1}.pem"
  }

  provisioner "file" {
    source      = "./certificate/kubelet/worker-${count.index+1}-key.pem"
    destination = "~/worker-${count.index+1}-key.pem"
  }


  provisioner "file" {
    source      = "./certificate/ca.pem"
    destination = "~/ca.pem"
  }

 
}
#_________________________________________

resource "null_resource" "ca-masters" {

  count = var.Mcount

  depends_on = [
    local_file.service-account_key,
    local_file.service-account_crt,
    local_file.kube_ca_key,
    local_file.kube_ca_crt,
    local_file.kubernetes_key,
    local_file.kubernetes_crt,
  ]

  connection {
    type         = "ssh"
    user         = var.user
    password     = var.password
    host         = "${aws_instance.k8s-MSTR[count.index].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }


  provisioner "file" {
    source      = "./certificate/ca.pem"
    destination = "~/ca.pem"
  }

  provisioner "file" {
    source      = "./certificate/ca-key.pem"
    destination = "~/ca-key.pem"
  }

  provisioner "file" {
    source      = "./certificate/kubernetes-key.pem"
    destination = "~/kubernetes-key.pem"

      }

      provisioner "file" {
    source      = "./certificate/kubernetes.pem"
    destination = "~/kubernetes.pem"

      }

provisioner "file" {
    source      = "./certificate/service-account-key.pem"
    destination = "~/service-account-key.pem"
    
      }

      provisioner "file" {
    source      = "./certificate/service-account.pem"
    destination = "~/service-account.pem"
    
      }

}