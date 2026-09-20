data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

# ---------------------------------------------------------------------------
# Controller role (assumed by the karpenter pod via EKS Pod Identity)
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "controller_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "controller" {
  name               = var.controller_role_name
  assume_role_policy = data.aws_iam_policy_document.controller_assume_role.json
  tags               = var.tags
}

resource "aws_eks_pod_identity_association" "controller" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.controller.arn
  tags            = var.tags
}

# Scoped per AWS's published Karpenter controller policy: manage EC2 capacity,
# pass the node role to launched instances, read pricing/SSM for instance
# selection, and drain the interruption queue.
data "aws_iam_policy_document" "controller" {
  statement {
    sid    = "AllowScopedEC2InstanceActions"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowScopedEC2LaunchTemplateActions"
    effect = "Allow"
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateTags",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowEC2ReadActions"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeSpotPriceHistory",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowEC2InstanceTermination"
    effect    = "Allow"
    actions   = ["ec2:TerminateInstances"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.sh/managed-by"
      values   = [var.cluster_name]
    }
  }

  statement {
    sid       = "AllowPassingInstanceRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.node.arn]
  }

  statement {
    sid    = "AllowInstanceProfileManagement"
    effect = "Allow"
    actions = [
      "iam:CreateInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:GetInstanceProfile",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowEKSClusterRead"
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:cluster/${var.cluster_name}"]
  }

  statement {
    sid       = "AllowPricingRead"
    effect    = "Allow"
    actions   = ["pricing:GetProducts", "ssm:GetParameter"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowInterruptionQueueRead"
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
    resources = [aws_sqs_queue.interruption.arn]
  }
}

resource "aws_iam_policy" "controller" {
  name        = "${var.controller_role_name}-policy"
  description = "Karpenter controller permissions, scoped to cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.controller.json
}

resource "aws_iam_role_policy_attachment" "controller" {
  role       = aws_iam_role.controller.name
  policy_arn = aws_iam_policy.controller.arn
}

# ---------------------------------------------------------------------------
# Node role (assumed by EC2 instances Karpenter launches)
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name               = var.node_role_name
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "node" {
  for_each   = toset(var.node_iam_managed_policies)
  role       = aws_iam_role.node.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "node" {
  name = var.node_role_name
  role = aws_iam_role.node.name
  tags = var.tags
}

# ---------------------------------------------------------------------------
# Interruption queue — Spot interruption / rebalance / instance state-change
# notifications Karpenter drains to terminate nodes gracefully.
# ---------------------------------------------------------------------------

resource "aws_sqs_queue" "interruption" {
  name                      = var.interruption_queue_name
  message_retention_seconds = var.message_retention_seconds
  sqs_managed_sse_enabled   = true
  tags                      = var.tags
}

data "aws_iam_policy_document" "interruption_queue" {
  statement {
    sid       = "AllowEventBridgeAndAWSHealthToSendMessages"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.interruption.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "interruption" {
  queue_url = aws_sqs_queue.interruption.id
  policy    = data.aws_iam_policy_document.interruption_queue.json
}

locals {
  interruption_event_patterns = {
    spot_interruption = { source = ["aws.ec2"], detail-type = ["EC2 Spot Instance Interruption Warning"] }
    rebalance         = { source = ["aws.ec2"], detail-type = ["EC2 Instance Rebalance Recommendation"] }
    instance_state    = { source = ["aws.ec2"], detail-type = ["EC2 Instance State-change Notification"] }
    scheduled_change  = { source = ["aws.health"], detail-type = ["AWS Health Event"] }
  }
}

resource "aws_cloudwatch_event_rule" "interruption" {
  for_each    = local.interruption_event_patterns
  name        = "${var.interruption_queue_name}-${each.key}"
  description = "Forwards ${each.key} events to the Karpenter interruption queue"
  event_pattern = jsonencode({
    source      = each.value.source
    detail-type = each.value["detail-type"]
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "interruption" {
  for_each = local.interruption_event_patterns
  rule     = aws_cloudwatch_event_rule.interruption[each.key].name
  arn      = aws_sqs_queue.interruption.arn
}
