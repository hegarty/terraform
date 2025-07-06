output "ids" {
  value = { for k, v in aws_nat_gateway.this : k => v.id }
}
