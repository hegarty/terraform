output "arns" {
  description = "Log group ARNs (without the trailing \":*\"), keyed by log group name."
  value       = { for name, g in aws_cloudwatch_log_group.this : name => g.arn }
}

output "names" {
  description = "Log group names, keyed by log group name."
  value       = { for name, g in aws_cloudwatch_log_group.this : name => g.name }
}
