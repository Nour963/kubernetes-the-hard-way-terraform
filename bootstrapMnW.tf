
resource "null_resource" "bash-masters" {
depends_on =[
  null_resource.ca-masters, 
  null_resource.kubcnf-masters,
  aws_lb.k8s-LB,
]
  count = var.Mcount


  connection {
    type         = "ssh"
    user         = var.user
    password     = var.password
    host         = "${aws_instance.k8s-MSTR[count.index].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }


  provisioner "remote-exec" {
    script = "./script/etcd.sh"  #modify if node count != 2
    
 
}
     provisioner "remote-exec" {
     script = "./script/masters.sh" #modify if node count != 2
}

}

resource "null_resource" "Only-master1" {
depends_on =[
  
  null_resource.bash-masters,
  
]
  

  connection {
    type         = "ssh"
    user         = var.user
    password     = var.password
    host         = "${aws_instance.k8s-MSTR[0].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }



provisioner "remote-exec" {

     script = "./script/clusterRole.sh"
}

}


resource "null_resource" "bash-workers" {
depends_on =[
  null_resource.Only-master1,
]
  count = var.Wcount


  connection {
    type         = "ssh"
    user         = var.user
    password     = var.password
    host         = "${aws_instance.k8s-WRKR[count.index].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }


  provisioner "remote-exec" {
    script = "./script/workers.sh"  
    
 
}
     
}