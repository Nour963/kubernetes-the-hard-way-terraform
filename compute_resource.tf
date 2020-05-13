provider "aws" {
    region = var.region

}

#VPC
resource "aws_vpc" "k8s_VPC" {
  cidr_block           = "10.240.0.0/24"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.name
  }
}

#SUBNET
resource "aws_subnet" "k8s-SUB" {
  vpc_id     = "${aws_vpc.k8s_VPC.id}"
  cidr_block = "10.240.0.0/24"

  tags = {
    Name = var.name
  }
}

#INETERNET GATEWAY
resource "aws_internet_gateway" "k8s-GW" {
  vpc_id = "${aws_vpc.k8s_VPC.id}"

  tags = {
    Name = var.name
  }
}

#ROUTE TABLE
resource "aws_route_table" "k8s-RT" {
  vpc_id = "${aws_vpc.k8s_VPC.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.k8s-GW.id}"
  }

  
  tags = {
    Name = var.name
  }
}

#ROUTING NODE'S PODS
resource "aws_route" "pod-route" {

depends_on                = [
      aws_route_table.k8s-RT,
      aws_instance.k8s-MSTR,
      ]

  count = var.Wcount
  route_table_id            = "${aws_route_table.k8s-RT.id}"
  destination_cidr_block    = "10.200.${count.index+1}.0/24"
  instance_id               = "${aws_instance.k8s-WRKR[count.index].id}"

  
}

#ROUTETABLE-SUBNET ASSOCIATION
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.k8s-SUB.id}"
  route_table_id = "${aws_route_table.k8s-RT.id}"
}


#SECURITY GROUP
resource "aws_security_group" "k8s-SG" {
  vpc_id      = "${aws_vpc.k8s_VPC.id}"
  name        = var.name
  description = "Kubernetes security group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.240.0.0/24"]
  }
  ingress {
    from_port   =  0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.200.0.0/16"]
  }

  
 ingress {
    from_port =   443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1 
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}

#LOAD BALANCER
resource "aws_lb" "k8s-LB" {
  name               = var.name
  internal           = false
  load_balancer_type = "network"
  

  subnet_mapping {
    subnet_id     = "${aws_subnet.k8s-SUB.id}"
      } 
  
  tags = {
    Name = var.name
  }
}

#TARGET GROUP
resource "aws_lb_target_group" "k8s-TG" {
  name        = var.name
  port        = 6443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.k8s_VPC.id}"
}

#TARGET GROUP ATTACHEMENT
resource "aws_lb_target_group_attachment" "k8s-TGA" {
  count            = var.Wcount
  target_group_arn = "${aws_lb_target_group.k8s-TG.arn}"
  target_id        = "10.240.0.1${count.index+1}"      #10.240.0.1{1,2}
  
}

#LISTENER
resource "aws_lb_listener" "k8s-LST" {
  load_balancer_arn  = "${aws_lb.k8s-LB.arn}"
  port               = "443"
  protocol           = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-TG.arn}"
  }
}

#SSH KEY
resource "aws_key_pair" "k8s-KEY" {
  key_name   = "k8shardkey"
  public_key = "${file("./key/k8shardkey.pem.pub")}"
}

#MASTER NODES
resource "aws_instance" "k8s-MSTR" {
  count                       = var.Mcount
  ami                         = var.ami
  instance_type               = var.instancetype
  key_name                    = "${aws_key_pair.k8s-KEY.key_name}"
  subnet_id                   = "${aws_subnet.k8s-SUB.id}"
  private_ip                  = "10.240.0.1${count.index + 1}"
  security_groups             = ["${aws_security_group.k8s-SG.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "name=master-${count.index + 1}"

  tags = {
    Name  = "master-${count.index + 1}"
    
  }
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }
 }

 
#WORKER NODES
resource "aws_instance" "k8s-WRKR" {
  count                       = var.Wcount
  ami                         = var.ami
  instance_type               = var.instancetype
  key_name                    = "${aws_key_pair.k8s-KEY.key_name}"
  subnet_id                   = "${aws_subnet.k8s-SUB.id}"
  private_ip                  = "10.240.0.2${count.index + 1}"
  security_groups             = ["${aws_security_group.k8s-SG.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "name=worker-${count.index + 1}|pod-cidr=10.200.${count.index+1}.0/24"

  tags = {
    Name  = "worker-${count.index + 1}"
    
  }
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }

 
}

 #LOCALY SAVE KUBERNETES LOADBALANCER DNS NAME
resource "local_file" "kub_pub_add" {
  content  = "${aws_lb.k8s-LB.dns_name}"
  filename = "./KUBERNETES_PUBLIC_ADDRESS"
}