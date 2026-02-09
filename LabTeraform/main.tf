provider "aws" {
  region = var.region
}

# 🔍 Fetch public IP (curl ifconfig.me equivalent)
data "http" "myip" {
  url = "https://ifconfig.me"
}

locals {
  my_public_ip = "${chomp(data.http.myip.response_body)}/32"
}

resource "aws_security_group" "ssh" {
  name        = "ec2-lab-ssh"
  description = "Allow SSH from my public IP"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_public_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-lab-ssh"
  }
}

resource "aws_instance" "lab" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "testproject"
    Environment = "lab"
    AutoDelete  = "true"
  }
}
