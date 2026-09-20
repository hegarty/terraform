locals {
  org_replacement = replace(aws_organizations_organization.this.roots[0].arn, "root", "organization")
  arn_parts       = split("/", local.org_replacement)
}

output "arn" {
  # aws_organizations_organization.this.arn returns a root ARN, not the organization ARN
  value       = "${local.arn_parts[0]}/${local.arn_parts[1]}"
  description = "The organization's ARN (derived, since the resource's own .arn attribute is actually the root's)"
}

output "roots" {
  value       = aws_organizations_organization.this.roots[0].arn
  description = "ARN of the organization's first root"
}
