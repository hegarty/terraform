locals {
  # I don't know why EKS does not support creating control plane instances in us-east-1e
  filtered_subnets = { for az, subnet_id in var.subnet_ids : az => subnet_id if az != "us-east-1e"
  }

  cluster_name = "${var.cluster_name}-self-managed-cluster"
}

resource "aws_cloudwatch_log_group" "example" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${aws_eks_cluster.this.name}"
  retention_in_days = 3

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_cluster" "this" {
  name     = "${var.cluster_name}-self-managed-cluster"
  role_arn = var.iam_arn

  vpc_config {
    subnet_ids         = values(local.filtered_subnets)
    security_group_ids = [aws_security_group.this.id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = "Production"
  }

  depends_on = [aws_security_group.this]
}
