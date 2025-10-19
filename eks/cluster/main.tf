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

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = var.environment
  }
}
