variable "aws_service_names" {
  description = "Service principals to create a service-linked role for, e.g. [\"spot.amazonaws.com\"]. One role per service per account."
  type        = list(string)

  validation {
    condition     = alltrue([for s in var.aws_service_names : endswith(s, ".amazonaws.com")])
    error_message = "Each entry must be a service principal ending in .amazonaws.com (e.g. spot.amazonaws.com)."
  }
}

variable "tags" {
  description = "Tags applied to each service-linked role."
  type        = map(string)
  default     = {}
}
