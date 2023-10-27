


# AWS region
region = "us-east-1"
project_name = "testing"

# EKS cluster version
cluster_version = 1.25


vpc_cidr_block = "10.20.0.0/16"
public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
private_subnets = {
  shared = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  dev    = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]
  prod   = ["10.20.50.0/24", "10.20.51.0/24", "10.20.52.0/24"]
}


eks_nodegroups = [
  {
    name           = "dev-spot"
    environment    = "dev"
    is_spot        = true
    min_size       = 1
    max_size       = 3
    desired_size   = 1
    instance_types = ["t3.small", "t3.medium"] # cluster autosclaer not working properly with *.small nodes
  },
  {
    name           = "dev-ondemand"
    environment    = "dev"
    is_spot        = false
    min_size       = 1
    max_size       = 3
    desired_size   = 1
    instance_types = ["t3.small", "t3.medium"]
  },
]
