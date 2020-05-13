variable "region" {
  type = string
  default = "eu-west-1" 
}

variable "name" {
  type = string
  default = "kubernetes" 
}

variable "Mcount" {
  type = string
  default = "2" 
}

variable "Wcount" {
  type = string
  default = "2" 
}

variable "ami" {
  type = string
  default = "ami-03ef731cc103c9f09"
}

variable "instancetype" {
  type = string
  default = "t3.micro"
}

#_______________________________________________________________________________________

variable "tlsalgo" {
  type = string
  default = "RSA"
}

variable "bitsalgo" {
  type = string
  default = "2048"
}

variable "user" {
  type = string
  default = "ubuntu"
}

variable "password" {
  type = string
  default = ""
}