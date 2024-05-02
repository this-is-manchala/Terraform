provider "aws" {
    region = "ap-south-1"
    secret_key = ""
    access_key = ""
}

variable "ami_id" {
  description = "value for AMI"
}

variable "intance_type" {
  description = "value for intance type"
}

resource "aws_instance" "example" {
  ami = var.ami_id
  instance_type = var.intance_type
}