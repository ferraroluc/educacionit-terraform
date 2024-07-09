resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "lab-subnet" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.lab-vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"
}

resource "aws_internet_gateway" "lab-igw" {
  vpc_id = aws_vpc.lab-vpc.id
}

resource "aws_route_table" "lab-rt" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab-igw.id
  }
}

resource "aws_route_table_association" "lab-rta" {
  subnet_id      = aws_subnet.lab-subnet.id
  route_table_id = aws_route_table.lab-rt.id
}

resource "aws_security_group" "lab-sg-ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.lab-vpc.id

  ingress {
    description = "allow ping"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
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
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "lab-key" {
  key_name   = "terraform_ec2_key"
  public_key = file("terraform-ec2-key.pub")
}

resource "aws_instance" "lab-vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.nano"
  key_name                    = aws_key_pair.lab-key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.lab-subnet.id
  security_groups             = [aws_security_group.lab-sg-ssh.id]

  user_data = <<-EOL
  #!/bin/bash -xe

  # Install and configure Docker
  apt update
  apt install -y docker.io
  addgroup --system docker
  adduser ubuntu docker
  newgrp docker
  EOL
}
