provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAZGRQFFW3MK8C7556N"
  secret_key = "NFVv5ObE9w5cwZSS15ldRaRGO2Hf6lQWQFvY+bbFb"
}

variable "ami" {
  description = "value for ami id"
}

variable "instance_type" {
  description = "value for instance type"
}

resource "aws_instance" "example" {
  ami = var.ami
  instance_type = var.instance_type
}
