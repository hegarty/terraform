# Account-wide IAM service-linked roles.
#
# A service-linked role is owned by an AWS service (it's that service, not
# your workloads, that assumes it) and exists at most once per account.
# Services normally create them lazily using the *caller's* credentials,
# which fails when the caller lacks iam:CreateServiceLinkedRole - e.g.
# Karpenter launching spot capacity without AWSServiceRoleForEC2Spot
# ("AuthFailure.ServiceLinkedRoleCreationNotPermitted"). Creating them up
# front removes that dependency on caller permissions.
#
# Keep this at account scope, never inside a cluster/workload module:
# destroying that module would delete a role the whole account relies on.
# AWS refuses the delete while the role is in use (e.g. running spot
# instances), so a destroy fails safely rather than breaking them.
#
# If a role already exists (created out of band), import it rather than
# letting apply fail with "has been taken in this account":
#   terraform import 'aws_iam_service_linked_role.this["spot.amazonaws.com"]' \
#     arn:aws:iam::<account>:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot
resource "aws_iam_service_linked_role" "this" {
  for_each = toset(var.aws_service_names)

  aws_service_name = each.value
  tags             = var.tags
}
