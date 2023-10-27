data "aws_caller_identity" "current" {}

data "aws_subnets" "eks_subnets" {
  for_each = var.private_subnets
  filter {
    name   = "cidr-block"
    values = each.value
  }
}

#data "aws_lb" "eks_ingress_lb" {
#  tags = {
#    "kubernetes.io/cluster/${var.project_name}-${var.environment}-cluster" = "owned"
#  }
#}

locals {
  account_id = data.aws_caller_identity.current.account_id
  eks_nodegroups = {
    for nodegroup in var.eks_nodegroups : nodegroup.name => {
      min_size     = nodegroup.min_size
      max_size     = nodegroup.max_size
      desired_size = nodegroup.desired_size

      update_config = {
        max_unavailable_percentage = 50
      }
      force_update_version    = true
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true

      instance_types = nodegroup.instance_types != null ? nodegroup.instance_types : null
      capacity_type  = nodegroup.is_spot ? "SPOT" : null

      subnet_ids = nodegroup.single_az ? [data.aws_subnets.eks_subnets[nodegroup.environment].ids[0]] : data.aws_subnets.eks_subnets[nodegroup.environment].ids

      ami_type = nodegroup.ami_type != null ? nodegroup.ami_type : null

      block_device_mappings = nodegroup.volume_size != null ? {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = nodegroup.volume_size
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      } : {}

      labels = {
        compute-type = "ec2"
#        env = nodegroup.environment
        env = nodegroup.custom_label != null ? "${nodegroup.environment}-${nodegroup.custom_label}" : nodegroup.environment
        type = nodegroup.type
        capacity_type = nodegroup.is_spot ? "spot" : "ondemand"
      }
    }
  }
}
