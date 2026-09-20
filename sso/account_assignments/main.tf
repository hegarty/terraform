data "aws_ssoadmin_instances" "this" {}

data "aws_ssoadmin_permission_set" "this" {
  for_each = { for a in var.assignments : "${a.account_id}/${a.permission_set_name}" => a }

  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = each.value.permission_set_name
}

data "aws_identitystore_group" "this" {
  for_each = { for a in var.assignments : "${a.account_id}/${a.permission_set_name}" => a }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.group_name
    }
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for a in var.assignments : "${a.account_id}/${a.permission_set_name}" => a }

  instance_arn       = data.aws_ssoadmin_permission_set.this[each.key].instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.this[each.key].arn

  principal_id   = data.aws_identitystore_group.this[each.key].group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
