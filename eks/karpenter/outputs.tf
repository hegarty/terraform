output "controller_role_arn" {
  value       = aws_iam_role.controller.arn
  description = "ARN of the IAM role assumed by the Karpenter controller via Pod Identity"
}

output "node_role_name" {
  value       = aws_iam_role.node.name
  description = "Name of the IAM role used by Karpenter-launched nodes"
}

output "node_role_arn" {
  value       = aws_iam_role.node.arn
  description = "ARN of the IAM role used by Karpenter-launched nodes"
}

output "node_instance_profile_name" {
  value       = aws_iam_instance_profile.node.name
  description = "Instance profile name to reference from the EC2NodeClass manifest"
}

output "interruption_queue_name" {
  value       = aws_sqs_queue.interruption.name
  description = "Name of the SQS interruption queue (reference from Karpenter's Helm values)"
}

output "interruption_queue_arn" {
  value = aws_sqs_queue.interruption.arn
}
