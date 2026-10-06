variable "stack_set_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_document" {
  description = "IAM policy document as a JSON string (e.g. jsonencode(...))"
  type        = string
}

variable "target_ou_ids" {
  description = "Organizational unit IDs (or the org root ID) to auto-deploy the policy to"
  type        = list(string)
}

variable "region" {
  description = "Single home region to deploy the stack instance to (IAM is global, one region is sufficient)"
  type        = string
}
