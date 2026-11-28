variable "log_groups" {
  description = "Log groups to create, keyed by log group name."
  type = map(object({
    retention_in_days = number
    kms_key_id        = optional(string)
    log_group_class   = optional(string, "STANDARD")
  }))

  validation {
    condition = alltrue([
      for g in values(var.log_groups) : contains(
        [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
        g.retention_in_days
      )
    ])
    error_message = "retention_in_days must be one of the values CloudWatch Logs accepts (1, 3, 5, 7, 14, 30, 60, 90, ...). Use an explicit value: 0 (never expire) is deliberately not allowed."
  }

  validation {
    condition     = alltrue([for g in values(var.log_groups) : contains(["STANDARD", "INFREQUENT_ACCESS"], g.log_group_class)])
    error_message = "log_group_class must be STANDARD or INFREQUENT_ACCESS."
  }
}

variable "tags" {
  description = "Tags applied to every log group."
  type        = map(string)
  default     = {}
}
