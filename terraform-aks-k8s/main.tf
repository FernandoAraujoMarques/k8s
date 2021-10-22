provider "aws" {
  region = "eu-central-1"
}

module "cluster" {
  source           = "weibeld/kubeadm/aws"
  version          = "~> 0.2"
  cluster_name     = "kubelabs"
}

output "nodes" {
  value = module.cluster.cluster_nodes
}