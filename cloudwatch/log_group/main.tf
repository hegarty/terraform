resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${aws_eks_cluster.this.name}/cluster"
  retention_in_days = var.retention_in_days
}
