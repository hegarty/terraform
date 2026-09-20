variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "iam_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "security_groups" {
  type = list(string)
}

variable "endpoint_public_access" {
  type = bool
}

variable "endpoint_private_access" {
  type = bool
}

variable "public_access_cidrs" {
  type = list(any)
}

variable "authentication_mode" {
  type = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type = bool
}

variable "enabled_cluster_log_types" {
  description = "Control plane log types to ship to CloudWatch Logs. Each type adds ingestion cost — keep this list short on cost-sensitive clusters."
  type        = list(string)
  default     = ["api", "audit"]
}
