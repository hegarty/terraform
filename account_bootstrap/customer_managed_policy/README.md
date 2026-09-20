# account_bootstrap/customer_managed_policy

Deploys a single customer-managed IAM policy into every account under a
target OU (or the org root) via an AWS Organizations-integrated,
service-managed CloudFormation StackSet with `auto_deployment` enabled.
AWS Organizations itself triggers deployment the moment an account is
created in (or moved into) a target OU/root — no CI/CD pipeline, no
Control Tower, no per-account Terraform apply required.

## Why this exists

IAM Identity Center permission sets can reference a customer-managed IAM
policy by name (`aws_ssoadmin_customer_managed_policy_attachment`), but
Identity Center never creates that policy itself — it must already exist,
by that exact name, in every target account before the permission set can
be provisioned there. For a brand-new account, nothing exists yet. This
module solves that for any single policy: point it at the OU/root your
accounts land in, and the policy exists in an account before you ever need
to provision a permission set against it.

Generic and parameterized on purpose (not hardcoded to one policy) so it
can be reused for a different customer-managed policy later without a new
module — just a new Terragrunt unit with different inputs.

## Usage

```hcl
module "claudeinvoke" {
  source = "git::https://github.com/hegarty/terraform.git//account_bootstrap/customer_managed_policy?ref=account_bootstrap/customer_managed_policy/v1.0.0"

  stack_set_name = "account-bootstrap-claudeinvoke"
  policy_name    = "claudeinvoke"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "bedrock:InvokeModel"
      Resource = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v2"
    }]
  })
  target_ou_ids = ["r-zebc"] # org root, or a specific OU ID
  region        = "us-east-1"
}
```

## Prerequisites

CloudFormation StackSets trusted access with AWS Organizations must already
be enabled (`member.org.stacksets.cloudformation.amazonaws.com` in the
org's `aws_service_access_principals`) — `permission_model = "SERVICE_MANAGED"`
will fail otherwise.

## No automated "is it done yet" signal

This module does not expose a wait/poll mechanism. `aws_cloudformation_stack_set_instance`
targeting `deployment_targets.organizational_unit_ids` doesn't create one
Terraform-tracked instance per account — AWS Organizations manages
per-account instances behind the scenes, including for accounts created
*after* this module is applied. Before provisioning an Identity Center
permission set against a new account, verify the policy actually landed:

```
aws cloudformation describe-stack-instance \
  --stack-set-name <stack_set_name> \
  --stack-instance-account <account-id> \
  --stack-instance-region <region> \
  --query 'StackInstance.StackInstanceStatus'
```

Expect `DetailedStatus: SUCCEEDED` before proceeding.
