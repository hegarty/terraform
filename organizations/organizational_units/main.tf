locals {
  # Flatten {parent_name => [child_name, ...]} into {"parent_name/child_name" => {parent, name}}
  # so any set of parent OUs and children works without editing this module.
  children = merge([
    for parent, kids in var.units : {
      for kid in kids : "${parent}/${kid}" => { parent = parent, name = kid }
    }
  ]...)
}

resource "aws_organizations_organizational_unit" "parent_ou" {
  for_each  = var.units
  name      = each.key
  parent_id = var.root_ou_id
  tags      = var.tags
}

resource "aws_organizations_organizational_unit" "child_ou" {
  for_each  = local.children
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.parent_ou[each.value.parent].id
  tags      = var.tags
}
