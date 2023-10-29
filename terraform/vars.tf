variable "project_name" {
  default     = "testing"
  description = "Main variable for project"
}

variable "environment" {
  default     = "shared"
  description = "Environment"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.20.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "EKS cluster public subnets"
}

variable "private_subnets" {
  type        = map(list(string))
  description = "EKS cluster private subnets"
}
variable "cluster_version" {
  default     = 1.25
  description = "EKS cluster version"
}

variable "eks_nodegroups" {
  type = list(object({
    name           = string
    environment    = optional(string, "shared")
    is_spot        = bool
    type           = optional(string, "general")
    min_size       = optional(number, 1)
    max_size       = number
    desired_size   = number
    volume_size    = optional(number)
    custom_label   = optional(string)
    instance_types = optional(list(string))
    ami_type       = optional(string)
    single_az      = optional(bool, false)
  }))
}
