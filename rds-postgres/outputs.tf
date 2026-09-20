output "db_instance_id" {
  value = aws_db_instance.this.id
}

output "endpoint" {
  value       = aws_db_instance.this.address
  description = "DB host (no port) — read the port separately, never parse this string"
}

output "port" {
  value = aws_db_instance.this.port
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "secret_arn" {
  value       = aws_secretsmanager_secret.this.arn
  description = "Secrets Manager ARN holding a JSON blob: {username,password,host,port,dbname}"
}
