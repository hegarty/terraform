data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}
output "cluster_id" {
  value = aws_eks_cluster.this
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "certificate-authority" {
  value = aws_eks_cluster.this.certificate_authority
}

output "api-server-endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_auth" {
  value     = data.aws_eks_cluster_auth.this.token
  sensitive = true
}
