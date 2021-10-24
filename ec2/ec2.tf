data "aws_security_group" "ubuntu" {
  name   = "ubuntu"
}

resource "aws_instance" "k8s" {
  count         = var.aws_instance_count
  private_dns = "8.8.8.8"
  ami           = var.aws_ami
  instance_type = var.aws_instance
  key_name      = "aws_fernando"
  tags = {
    Name = "knode-k8s-${count.index + 1}"
  }
}

resource "null_resource" "remote-exec" {
  triggers = {
    public_ip = element(concat(aws_instance.k8s.*.public_ip,[""]), 0)
  }

  connection {
    type  = "ssh"
    host  = element(concat(aws_instance.k8s.*.public_ip,[""]), 0)
    user  = "ubuntu"
    private_key = file ("aws_fernando.pem")
  }

  // apt update and apt install
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "curl https://releases.rancher.com/install-docker/20.10.sh | sh",
      "sudo apt-get update -y",
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg"
      "echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list"",
      "sudo apt-get update",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo apt-mark hold kubelet kubeadm kubectl",
      "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      "chmod +x kubectl",
      "mkdir -p ~/.local/bin/kubectl",
      "mv ./kubectl ~/.local/bin/kubectl",
    ]
  }
}
