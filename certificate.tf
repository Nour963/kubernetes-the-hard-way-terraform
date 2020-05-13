#____________________________CA______________________________________

resource "tls_private_key" "kube_ca" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_self_signed_cert" "kube_ca" {
  key_algorithm          = tls_private_key.kube_ca.algorithm
  private_key_pem        = tls_private_key.kube_ca.private_key_pem

  subject {
    common_name          = "Kubernetes"
    organization         = "Kubernetes"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "CA"
    
  }

  is_ca_certificate      = true
  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_ca_key" {
  content                 = tls_private_key.kube_ca.private_key_pem
  filename                = "./certificate/ca-key.pem"
}

resource "local_file" "kube_ca_crt" {
  content                 = tls_self_signed_cert.kube_ca.cert_pem
  filename                = "./certificate/ca.pem"
}

#__ADMIN___________________________________________________________________

resource "tls_private_key" "kube_admin" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kube_admin" {
  key_algorithm           = tls_private_key.kube_admin.algorithm
  private_key_pem         = tls_private_key.kube_admin.private_key_pem

  subject {
    common_name           = "admin"
    organization          = "system:masters"
    country               = "US"
    locality              = "Portland"
    organizational_unit   = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "kube_admin" {
  cert_request_pem       = tls_cert_request.kube_admin.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_admin_key" {
  content                = tls_private_key.kube_admin.private_key_pem
  filename               = "./certificate/admin-key.pem"
}

resource "local_file" "kube_admin_crt" {
  content                = tls_locally_signed_cert.kube_admin.cert_pem
  filename               = "./certificate/admin.pem"
}

#CONTROLLER-MANAGER____________________________________________

resource "tls_private_key" "kube_controller_manager" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kube_controller_manager" {
  key_algorithm          = tls_private_key.kube_controller_manager.algorithm
  private_key_pem        = tls_private_key.kube_controller_manager.private_key_pem

  subject {
    common_name          = "system:kube-controller-manager"
    organization         = "system:kube-controller-manager"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "kube_controller_manager" {
  cert_request_pem       = tls_cert_request.kube_controller_manager.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_controller_manager_key" {
  content                = tls_private_key.kube_controller_manager.private_key_pem
  filename               = "./certificate/kube-controller-manager-key.pem"
}

resource "local_file" "kube_controller_manager_crt" {
  content                = tls_locally_signed_cert.kube_controller_manager.cert_pem
  filename               = "./certificate/kube-controller-manager.pem"
}

#______________KUBE PROXY_________________________

resource "tls_private_key" "kube_proxy" {
 algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kube_proxy" {
  key_algorithm          = tls_private_key.kube_proxy.algorithm
  private_key_pem        = tls_private_key.kube_proxy.private_key_pem

  subject {
    common_name          = "system:kube-proxy"
    organization         = "system:node-proxier"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
   
  }
}

resource "tls_locally_signed_cert" "kube_proxy" {
  cert_request_pem       = tls_cert_request.kube_proxy.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_proxy_key" {
  content                = tls_private_key.kube_proxy.private_key_pem
  filename               = "./certificate/kube-proxy-key.pem"
}

resource "local_file" "kube_proxy_crt" {
  content                = tls_locally_signed_cert.kube_proxy.cert_pem
  filename               = "./certificate/kube-proxy.pem"
}

#_______________SCHEDULER__________________________
resource "tls_private_key" "kube_scheduler" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kube_scheduler" {
  key_algorithm          = tls_private_key.kube_scheduler.algorithm
  private_key_pem        = tls_private_key.kube_scheduler.private_key_pem

  subject {
    common_name          = "system:kube-scheduler"
    organization         = "system:kube-scheduler"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "kube_scheduler" {
  cert_request_pem       = tls_cert_request.kube_scheduler.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kube_scheduler_key" {
  content                = tls_private_key.kube_scheduler.private_key_pem
  filename               = "./certificate/kube-scheduler-key.pem"
}

resource "local_file" "kube_scheduler_crt" {
  content                = tls_locally_signed_cert.kube_scheduler.cert_pem
  filename               = "./certificate/kube-scheduler.pem"
}

#__________________SERVICE ACCOUNT___________________
resource "tls_private_key" "service-account" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "service-account" {
  key_algorithm          = tls_private_key.service-account.algorithm
  private_key_pem        = tls_private_key.service-account.private_key_pem

  subject {
    common_name          = "service-accounts"
    organization         = "Kubernetes"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "service-account" {
  cert_request_pem       = tls_cert_request.service-account.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "service-account_key" {
  content                = tls_private_key.service-account.private_key_pem
  filename               = "./certificate/service-account-key.pem"
}

resource "local_file" "service-account_crt" {
  content                = tls_locally_signed_cert.service-account.cert_pem
  filename               = "./certificate/service-account.pem"
}

#___________________________API SERVER_________________________
resource "tls_private_key" "kubernetes" {
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kubernetes" {

  depends_on = [
   aws_lb.k8s-LB,

  ]

  key_algorithm          = tls_private_key.kubernetes.algorithm
  private_key_pem        = tls_private_key.kubernetes.private_key_pem

  ip_addresses = flatten([
    "10.240.0.11",
    "10.240.0.12",
    "127.0.0.1",
    "10.32.0.1",
    
  ])
  dns_names = [
    "kubernetes.default",
    "${aws_lb.k8s-LB.dns_name}",
  ]

  subject {
    common_name          = "kubernetes"
    organization         = "Kubernetes"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "kubernetes" {
  cert_request_pem       = tls_cert_request.kubernetes.cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kubernetes_key" {
  content                = tls_private_key.kubernetes.private_key_pem
  filename               = "./certificate/kubernetes-key.pem"
}

resource "local_file" "kubernetes_crt" {
  content                = tls_locally_signed_cert.kubernetes.cert_pem
  filename               = "./certificate/kubernetes.pem"
}

#_______________KUBELET_________________________
resource "tls_private_key" "kubelet" {
  count                  = var.Wcount
  algorithm              = var.tlsalgo
  rsa_bits               = var.bitsalgo
}

resource "tls_cert_request" "kubelet" {
  key_algorithm          = tls_private_key.kubelet[count.index].algorithm
  private_key_pem        = tls_private_key.kubelet[count.index].private_key_pem
  count                  = var.Wcount

  lifecycle {
    ignore_changes       = [id]
  }

  ip_addresses = [
    "${aws_instance.k8s-WRKR[count.index].private_ip}",
    "${aws_instance.k8s-WRKR[count.index].public_ip}"
  ]
 
  dns_names = [
    "ip-10-240-0-2${count.index+1}"
  ]

  subject {
    common_name          = "system:node:ip-10-240-0-2${count.index+1}"     
    organization         = "system:nodes"
    country              = "US"
    locality             = "Portland"
    organizational_unit  = "Kubernetes The Hard Way"
    
  }
}

resource "tls_locally_signed_cert" "kubelet" {
  count                  = var.Wcount
  cert_request_pem       = tls_cert_request.kubelet[count.index].cert_request_pem
  ca_key_algorithm       = tls_private_key.kube_ca.algorithm
  ca_private_key_pem     = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem            = tls_self_signed_cert.kube_ca.cert_pem
 
  validity_period_hours  = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kubelet_key" {
  count                  = var.Wcount

  content                = tls_private_key.kubelet[count.index].private_key_pem
  filename               = "./certificate/kubelet/worker-${count.index+1}-key.pem"
}

resource "local_file" "kubelet_crt" {
  count                  = var.Wcount

  content                = tls_locally_signed_cert.kubelet[count.index].cert_pem
  filename               = "./certificate/kubelet/worker-${count.index+1}.pem"
}
 