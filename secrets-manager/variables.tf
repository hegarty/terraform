variable "name" {
  type        = string
  description = "Secret name, e.g. commerce-intel/shopify/devmoto"
}

variable "description" {
  type    = string
  default = "Managed by Terraform (secrets-manager module)"
}

variable "recovery_window_in_days" {
  type        = number
  default     = 7
  description = "Days AWS retains the secret after deletion before it's unrecoverable. 0 disables the recovery window."
}

variable "initial_value" {
  type        = string
  description = "Optional initial secret value. Leave null to create an empty secret shell populated out-of-band (e.g. Shopify tokens set manually after apply)."
  default     = null
  sensitive   = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
