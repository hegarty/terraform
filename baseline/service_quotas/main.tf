resource "aws_servicequotas_service_quota" "this" {
  for_each     = { for q in var.quotas : "${q.service_code}/${q.quota_code}" => q }
  quota_code   = each.value.quota_code
  service_code = each.value.service_code
  value        = each.value.limit
}
