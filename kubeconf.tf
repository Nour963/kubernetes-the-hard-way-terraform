
#____________________________KUBE-PROXY____________________________________
data "template_file" "kube-proxy" {
 depends_on= [
   aws_lb.k8s-LB
 ]
    template = "${file("./kubeconf/kube-proxy.tpl")}"

    vars = {
      

        kub_public_add    = "${aws_lb.k8s-LB.dns_name}"
        ca_path           = base64encode(tls_self_signed_cert.kube_ca.cert_pem)
        kube_proxy_c_path = base64encode(tls_locally_signed_cert.kube_proxy.cert_pem)
        kube_proxy_k_path = base64encode(tls_private_key.kube_proxy.private_key_pem)

    }

}

resource "local_file" "kube_proxy" {
  content  = "${data.template_file.kube-proxy.rendered}"
  filename = "./kubeconf/kube-proxy.kubeconfig"
}


#____________________________CONTROLLER-MANAGER__________________________________________

data "template_file" "kube-ctrl" {

    template = "${file("./kubeconf/kube-controller-manager.tpl")}"

      vars = {

        ca_path                        = base64encode(tls_self_signed_cert.kube_ca.cert_pem)
        kube-controller-manager_c_path = base64encode(tls_locally_signed_cert.kube_controller_manager.cert_pem)
        kube-controller-manager_k_path = base64encode(tls_private_key.kube_controller_manager.private_key_pem)
    }

}

resource "local_file" "kube_ctrl" {
  content  = "${data.template_file.kube-ctrl.rendered}"
  filename = "./kubeconf/kube-controller-manager.kubeconfig"
}

#___________________ADMIN__________________________________________________

data "template_file" "admin" {

    template = "${file("./kubeconf/admin.tpl")}"

    vars = {

        ca_path      = base64encode(tls_self_signed_cert.kube_ca.cert_pem)
        admin_c_path = base64encode(tls_locally_signed_cert.kube_admin.cert_pem)
        admin_k_path = base64encode(tls_private_key.kube_admin.private_key_pem)
    }

}

resource "local_file" "kube_admin" {
  content  = "${data.template_file.admin.rendered}"
  filename = "./kubeconf/admin.kubeconfig"
}

#__________________SCHEDULER___________________________________________________

data "template_file" "kube_sch" {

    template = "${file("./kubeconf/kube-scheduler.tpl")}"

    vars = {

        ca_path               = base64encode(tls_self_signed_cert.kube_ca.cert_pem)
        kube-scheduler_c_path = base64encode(tls_locally_signed_cert.kube_scheduler.cert_pem)
        kube-scheduler_k_path = base64encode(tls_private_key.kube_scheduler.private_key_pem)

} 

}

resource "local_file" "kube_sch" {
  content  = "${data.template_file.kube_sch.rendered}"
  filename = "./kubeconf/kube-scheduler.kubeconfig"
}

#_____________WORKER____________________________________________________

data "template_file" "kube_wrk" {

    count = var.Wcount
    template = "${file("./kubeconf/worker.tpl")}"

        depends_on = [
    
  local_file.kube_ca_crt,
  local_file.kubelet_key,
  local_file.kubelet_crt,
  aws_lb.k8s-LB,
  ]

    vars = {
        kub_public_add = "${aws_lb.k8s-LB.dns_name}"
        ca_path        = base64encode(tls_self_signed_cert.kube_ca.cert_pem)
        node_c_path    = base64encode(tls_locally_signed_cert.kubelet[count.index].cert_pem)
        node_k_path    =  base64encode(tls_private_key.kubelet[count.index].private_key_pem)
        node           = "worker-${count.index+1}"

    }

}

resource "local_file" "kube_wrk" {
  count = var.Wcount
  content  = "${data.template_file.kube_wrk[count.index].rendered}"
  filename = "./kubeconf/worker-${count.index+1}.kubeconfig"
} 