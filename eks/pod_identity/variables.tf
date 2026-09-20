variable "cluster_name" {
  type        = string
  description = "EKS cluster name to associate this Pod Identity role with"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace of the workload's ServiceAccount"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes ServiceAccount name this role is associated with"
}

variable "role_name" {
  type        = string
  description = "Name for the IAM role assumed via EKS Pod Identity"
}

variable "policy_name" {
  type        = string
  description = "Name for the custom IAM policy (only used if var.policy is set)"
  default     = null
}

variable "policy_description" {
  type    = string
  default = "Managed by Terraform (eks/pod_identity module)"
}

variable "policy" {
  type        = string
  description = "Custom IAM policy JSON document to attach, or null to skip"
  default     = null
}

variable "aws_managed_policies" {
  type        = list(string)
  description = "List of AWS-managed policy ARNs to attach"
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
