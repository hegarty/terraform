# CloudWatch Logs log groups, created up front with explicit retention.
#
# Create log groups here rather than letting writers (e.g. the OTel
# Collector's awscloudwatchlogs exporter) create them on first write:
# writer-created groups default to "Never expire", and the writer then
# needs logs:CreateLogGroup. With the groups managed here, writers only
# need CreateLogStream/PutLogEvents/DescribeLogStreams on their own group.
#
# Separate from cloudwatch/log_group (singular), which is hard-wired to an
# EKS control-plane group name and consumed elsewhere as-is.
resource "aws_cloudwatch_log_group" "this" {
  for_each = var.log_groups

  name              = each.key
  retention_in_days = each.value.retention_in_days
  kms_key_id        = each.value.kms_key_id
  log_group_class   = each.value.log_group_class

  tags = var.tags
}
