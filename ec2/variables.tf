variable "aws_name" {
  type = string
  default = "knode-k8s"
}
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_ami" {
  type    = string
  default = "ami-00cddf542dc3da8d2"
}

variable "aws_instance" {
  type    = string
  default = "t2.medium"
}

variable "aws_instance_count" {
  type    = string
  default = "2"
}