provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}

variable "cidr" {
  description = "value for CIDR range for VPC"
  default = "10.0.0.0/10"
}

resource "aws_vpc" "example" {
  cidr_block = var.cidr
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_customer_owned_ip_on_launch = true

  tags = {
    Name = "Example"
  }
}

resource "aws_internet_gateway" "exam_igw" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.exam_igw.id
  }

  tags = {
    Name = "example"
  }
}
resource "aws_route_table_association" "exam_rta" {
  subnet_id = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  name = "example"
  vpc_id = aws_vpc.example.id

    ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "HTTP from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "Trianz1"
    vpc_security_group_ids = [aws_security_group.example.id]
    subnet_id = aws_subnet.example.id

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "Trianz1.pem"
      host = self.public_ip
    }

    provisioner "file" {
      source = "app.py"
      destination = "/home/ec2-user/app.py"
    }

    provisioner "remote-exec" {
      inline = [ 
        "echo 'Hello from the remote instance'",
        "sudo yum update -y",  # Update package lists (for ubuntu)
        "sudo yum install -y python3-pip",  # Example package installation
        "cd /home/ec2-user",
        "sudo pip3 install flask",
        "sudo python3 app.py &",
       ]
    }
}


