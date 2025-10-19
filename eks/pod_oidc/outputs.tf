locals {
  uri = trimsuffix(trimprefix(aws_iam_openid_connect_provider.this.url, "https://"), "/")
  uri_parts = split("/", local.uri)
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.this.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

output "oidc_issuer_host" {
  value = aws_iam_openid_connect_provider.this.url
}

output "oidc_id" {
  value = local.uri_parts[length(local.uri_parts) - 1]
}

output "oidc_url" {
  value = aws_iam_openid_connect_provider.this.url
}
