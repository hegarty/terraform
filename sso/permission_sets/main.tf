data "aws_ssoadmin_instances" "this" {}

locals {
  # Flatten every permission set's managed_policy_arn list into
  # {"<permission_set_name>/<policy_arn>" => {...}} so any permission set with
  # managed policies gets them attached, not just a single hardcoded one.
  managed_policy_attachments = merge([
    for ps in var.permission_sets : {
      for policy_arn in coalesce(ps.managed_policy_arn, []) :
      "${ps.permission_set_name}/${policy_arn}" => {
        permission_set_name = ps.permission_set_name
        policy_arn          = policy_arn
      }
    }
  ]...)
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each         = { for ps in var.permission_sets : ps.permission_set_name => ps }
  name             = each.value.permission_set_name
  description      = each.value.permission_set_description
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  relay_state      = "https://${each.value.relay_state_region}.console.aws.amazon.com/console/home?=${each.value.relay_state_region}#"
  session_duration = each.value.session_duration

  tags = var.tags
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = local.managed_policy_attachments

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_name].arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = {
    for ps in var.permission_sets : ps.permission_set_name => ps
    if ps.customer_managed_policy_name != null
  }

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn

  customer_managed_policy_reference {
    name = each.value.customer_managed_policy_name
    path = "/"
  }
}
