resource "aws_organizations_account" "this" {
  for_each  = { for account in var.member_accounts : account.name => account }
  name      = each.value.name
  email     = each.value.email
  parent_id = each.value.parent_ou_id
}
