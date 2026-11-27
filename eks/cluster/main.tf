locals {
  #EKS does not support creating control plane instances in us-east-1e
  filtered_subnets = { for az, subnet_id in var.subnet_ids : az => subnet_id if az != "us-east-1e"
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.iam_arn

  vpc_config {
    subnet_ids         = values(local.filtered_subnets)
    security_group_ids = var.security_groups

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  access_config {
    authentication_mode = var.authentication_mode # later you can switch to "API"
    # bootstrap_cluster_creator_admin_permissions = false
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = {
    Environment = var.environment
  }
}

# The cluster's security group (vpc_config.cluster_security_group_id) is
# created automatically by EKS, not as a resource this module declares -
# so it can't be tagged via `aws_eks_cluster.this.tags`. aws_ec2_tag lets
# Terraform manage individual tags on a resource it doesn't otherwise own.
resource "aws_ec2_tag" "cluster_security_group" {
  for_each    = var.cluster_security_group_tags
  resource_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}
