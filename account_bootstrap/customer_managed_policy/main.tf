locals {
  template = jsonencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Resources = {
      BootstrapPolicy = {
        Type = "AWS::IAM::ManagedPolicy"
        Properties = {
          ManagedPolicyName = var.policy_name
          PolicyDocument    = jsondecode(var.policy_document)
        }
      }
    }
  })
}

resource "aws_cloudformation_stack_set" "this" {
  name             = var.stack_set_name
  permission_model = "SERVICE_MANAGED"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  template_body    = local.template

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }
}

resource "aws_cloudformation_stack_set_instance" "this" {
  stack_set_name = aws_cloudformation_stack_set.this.name
  region         = var.region

  deployment_targets {
    organizational_unit_ids = var.target_ou_ids
  }
}
