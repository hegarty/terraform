resource "aws_eks_access_entry" "this" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn # e.g., the AWSReservedSSO_* role ARN you use
  type          = var.node_type
}

# EC2_LINUX/EC2_WINDOWS/FARGATE_LINUX access entries authorize node bootstrap
# on their own; AWS rejects an explicit policy association against them
# ("can only be performed on Access Entries with a type of STANDARD"). Only
# associate a policy when this is a true STANDARD entry (node_type unset).
resource "aws_eks_access_policy_association" "this" {
  count = var.node_type == null ? 1 : 0

  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
  policy_arn    = var.policy_arn
  access_scope { type = var.access_scope_type }

  depends_on = [aws_eks_access_entry.this]
}
