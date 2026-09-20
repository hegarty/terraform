resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

# Only seeds an initial version when a value is supplied at apply time (e.g. a
# Terraform-generated password). Values populated out-of-band afterwards
# (Shopify tokens, SMS provider keys, manual rotation) are never overwritten
# by a later `apply` — this resource does not track drift on secret_string.
resource "aws_secretsmanager_secret_version" "this" {
  count         = var.initial_value != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.initial_value

  lifecycle {
    ignore_changes = [secret_string]
  }
}
