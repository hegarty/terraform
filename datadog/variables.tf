variable "secret_name" {
  description = "Secrets Manager secret holding a JSON object with datadog_api_key and datadog_app_key"
  type        = string
  default     = "datadog/keys"
}

variable "included_regions" {
  description = "AWS regions to enable AWS integration metric collection for (the current provider uses an include-list, not an exclude-list)"
  type        = list(string)
  default     = ["us-east-1"]
}

variable "account_name" {
  type = string
}

variable "account_env" {
  type = string
}

variable "account_id" {
  type = string
}

variable "plz_env" {
  type = string
}
