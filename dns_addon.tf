
resource "null_resource" "dns_addon" {
depends_on =[
  null_resource.bash-workers,
  
]
  

  connection {
    type         = "ssh"
    user         = var.user
    password     = var.password
    host         = "${aws_instance.k8s-MSTR[0].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }



provisioner "remote-exec" {
     inline = ["kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml"]

}

}