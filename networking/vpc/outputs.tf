output "vpc" {
  value = aws_vpc.this
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnets" {
  value = aws_subnet.this
}
