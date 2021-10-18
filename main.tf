terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

data "aws_security_group" "default" {
  name   = "ubuntu"
}

resource "aws_instance" "k8s" {
  count         = var.aws_instance_count
  ami           = var.aws_ami
  instance_type = var.aws_instance
  key_name      = "aws_fernando"
  tags = {
    Name = var.aws_name
  }
}

resource "null_resource" "remote-exec" {
  triggers = {
    public_ip = aws_instance.k8s.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.k8s.public_ip
    user  = "ubuntu"
    private_key = file ("aws_fernando.pem")
  }

  // apt update and apt install
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",

    ]
  }
}
