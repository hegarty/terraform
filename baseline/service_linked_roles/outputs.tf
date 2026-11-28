output "role_arns" {
  description = "Service-linked role ARNs, keyed by AWS service name."
  value       = { for svc, r in aws_iam_service_linked_role.this : svc => r.arn }
}

output "role_names" {
  description = "Service-linked role names, keyed by AWS service name."
  value       = { for svc, r in aws_iam_service_linked_role.this : svc => r.name }
}
