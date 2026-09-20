locals {
  cidr_association_list = flatten([
    for account in var.member_accounts : [
      for i, cidr in account.cidr : {
        cidr = cidr
        name = format("%s_vpc-%s", account.name, i + 1)
        env  = account.environment
      }
    ]
  ])
  account_envs = toset(var.member_accounts[*].environment)
}

output "cidrs" {
  description = "CIDR allocations nested by environment: {env => {name => cidr}}"
  value = {
    for env in local.account_envs : env => {
      for c in local.cidr_association_list : c.name => c.cidr if c.env == env
    }
  }
}

output "all_cidrs" {
  value = { for c in local.cidr_association_list : c.name => c.cidr }
}

output "account_id_by_name" {
  description = "Map of account name => newly created AWS account ID, so it doesn't have to be hand-copied from the console"
  value       = { for name, account in aws_organizations_account.this : name => account.id }
}
