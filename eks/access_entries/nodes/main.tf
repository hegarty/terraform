resource "aws_eks_access_entry" "this" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn   # e.g., the AWSReservedSSO_* role ARN you use
  type = var.node_type
}
/*
resource "aws_eks_access_policy_association" "this" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
  policy_arn    = var.policy_arn
  access_scope  { type = var.access_scope_type }
}
*/
