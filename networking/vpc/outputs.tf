output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = { for k, v in aws_subnet.this : v.availability_zone_id => v.id if v.tags.type == "public" }
}

output "controller_subnets" {
  value = { for v in aws_subnet.this : v.availability_zone_id => v.id if v.tags.use == "controller" }
}

output "worker_subnets" {
  value = { for v in aws_subnet.this : v.availability_zone_id => v.id if v.tags.use == "worker" }
}
