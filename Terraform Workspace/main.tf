provider "aws" {
    region = "ap-south-1"
    secret_key = ""
    access_key = ""
}
variable "ami_id" {
  description = "value"
}

variable "instance_type" {
  description = "value"
}

module "ec2_instance" {
    source = "./Modules/ec2_instance"
    ami_id = var.ami_id
    intance_type = var.instance_type
}