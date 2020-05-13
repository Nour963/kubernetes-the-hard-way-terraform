data "template_file" "admin_kubectl" {

 depends_on = [
   aws_lb.k8s-LB,
   local_file.kubernetes_crt,
   local_file.kube_admin_key,
   local_file.kube_admin_crt,
  ]

template = "${file("./kubeconf/admin_kubectl.tpl")}"

    vars = {
        kub_public_add = "${aws_lb.k8s-LB.dns_name}"
}

}

resource "local_file" "admin_kubectl" {
  content  = "${data.template_file.admin_kubectl.rendered}"
  filename = "./admin_kubectl.sh"
} 

resource "null_resource" "bash_adminkubectl" {
 depends_on =[
 local_file.admin_kubectl
 ]
  provisioner "local-exec" {
     command = " bash ./admin_kubectl.sh"
  }
}