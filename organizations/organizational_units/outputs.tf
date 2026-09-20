output "parent_ou_by_name" {
  value = aws_organizations_organizational_unit.parent_ou
}

output "child_ou_by_name" {
  description = "Keyed by \"<parent>/<child>\", e.g. \"workloads/prod\""
  value       = aws_organizations_organizational_unit.child_ou
}
