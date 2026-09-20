output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "ARN of the IAM role assumed by the workload via EKS Pod Identity"
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "Name of the IAM role"
}

output "association_id" {
  value       = aws_eks_pod_identity_association.this.association_id
  description = "ID of the Pod Identity association"
}
