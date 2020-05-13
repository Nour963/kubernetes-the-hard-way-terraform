
resource "random_string" "encryptkey" {
  length = 32
  
}

resource "local_file" "encryptkey" {
  content                = base64encode(random_string.encryptkey.result)
  filename               = "./key/Encryption-key"
}

data "template_file" "encrypt" {
 
    template = "${file("./kubeconf/encrypt.tpl")}"

    vars = {
        ENCRYPTION_KEY= local_file.encryptkey.content
    }

}

resource "local_file" "encrypt" {
  content  = "${data.template_file.encrypt.rendered}"
  filename = "./kubeconf/encryption-config.yaml"
}

resource "null_resource" "encrypt-masters" {

  count = var.Mcount


  connection {
    type         = "ssh"
    user         =  var.user
    password     = var.password
    host         = "${aws_instance.k8s-MSTR[count.index].public_ip}"
    private_key  = "${file("./key/k8shardkey.pem")}"
   
  }


  provisioner "file" {
    source      = "./kubeconf/encryption-config.yaml"
    destination = "~/encryption-config.yaml"
  }
}