locals {
  #s = cidrsubnets(var.vpc_cidr,7,7,4,4,4,2,2,2)
}

resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = var.assign_ipv6
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames

  tags = {
    Name        = format("%s-%s-vpc", var.vpc_name, var.environment)
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      tags,
      enable_dns_support,
      enable_dns_hostnames
    ]
  }
}

resource "aws_subnet" "this" {
  for_each = { for v in var.subnets : "${v.use}_${v.availability_zone_id}" => v }

  vpc_id               = aws_vpc.this.id
  cidr_block           = each.value.cidr
  availability_zone_id = each.value.availability_zone_id

  tags = merge(
    {
      Name        = format("%s-%s-%s", var.vpc_name, var.environment, each.key)
      Environment = var.environment
    },
    each.value.tags
  )
}
