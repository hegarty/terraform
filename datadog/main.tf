terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "this" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id
}

locals {
  datadog_api_key = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["datadog_api_key"]
  datadog_app_key = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["datadog_app_key"]
}

provider "datadog" {
  api_key = local.datadog_api_key
  app_key = local.datadog_app_key
}

resource "datadog_integration_aws_external_id" "this" {}

resource "datadog_integration_aws_account" "this" {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = "aws"

  account_tags = [
    "plz_env:${var.plz_env}",
    "aws_account_name:${var.account_name}",
    "aws_account_id:${var.account_id}",
    "aws_account_env:${var.account_env}"
  ]

  auth_config {
    aws_auth_config_role {
      role_name   = aws_iam_role.this.name
      external_id = datadog_integration_aws_external_id.this.id
    }
  }

  aws_regions {
    include_only = var.included_regions
  }

  logs_config {
    lambda_forwarder {
      lambdas = []
      sources = []
    }
  }

  metrics_config {
    enabled = true
    namespace_filters {
      exclude_only = []
    }
  }

  resources_config {
    extended_collection = true
  }

  traces_config {
    xray_services {
      include_all = false
    }
  }
}

resource "aws_iam_role" "this" {
  name = "datadog-integration-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          # Datadog's own AWS account, per their integration docs
          "AWS" : "arn:aws:iam::464622532012:root"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : datadog_integration_aws_external_id.this.id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name        = "datadog-integration-policy"
  path        = "/"
  description = "Datadog integration policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "apigateway:GET",
          "autoscaling:Describe*",
          "budgets:ViewBudget",
          "cloudformation:DetectStack*",
          "cloudfront:GetDistributionConfig",
          "cloudfront:ListDistributions",
          "cloudtrail:LookupEvents",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "codedeploy:List*",
          "codedeploy:BatchGet*",
          "directconnect:Describe*",
          "dynamodb:List*",
          "dynamodb:Describe*",
          "ec2:Describe*",
          "ecs:Describe*",
          "ecs:List*",
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeTags",
          "elasticloadbalancing:Describe*",
          "elasticmapreduce:List*",
          "elasticmapreduce:Describe*",
          "es:ListTags",
          "es:ListDomainNames",
          "es:DescribeElasticsearchDomains",
          "fsx:DescribeFileSystems",
          "health:DescribeEvents",
          "health:DescribeEventDetails",
          "health:DescribeAffectedEntities",
          "kinesis:List*",
          "kinesis:Describe*",
          "lambda:AddPermission",
          "lambda:GetPolicy",
          "lambda:List*",
          "lambda:RemovePermission",
          "logs:Get*",
          "logs:Describe*",
          "logs:FilterLogEvents",
          "logs:TestMetricFilter",
          "logs:PutSubscriptionFilter",
          "logs:DeleteSubscriptionFilter",
          "logs:DescribeSubscriptionFilters",
          "organizations:DescribeOrganization",
          "rds:Describe*",
          "rds:List*",
          "redshift:DescribeClusters",
          "redshift:DescribeLoggingStatus",
          "route53:List*",
          "s3:GetBucketLogging",
          "s3:GetBucketLocation",
          "s3:GetBucketNotification",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
          "s3:PutBucketNotification",
          "ses:Get*",
          "sns:List*",
          "sns:Publish",
          "states:ListStateMachines",
          "states:DescribeStateMachine",
          "sqs:ListQueues",
          "support:*",
          "tag:GetResources",
          "tag:GetTagKeys",
          "tag:GetTagValues",
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
