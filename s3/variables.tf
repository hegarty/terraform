variable "bucket_name" {
  type        = string
  description = "Globally unique name for the S3 bucket"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow bucket deletion even when it contains objects"
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Enable versioning on the bucket"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources"
}

variable "lifecycle_rules" {
  description = <<-EOT
    Optional lifecycle rules. Each entry:
      id              = string, rule name
      enabled         = bool
      prefix          = optional string, defaults to whole bucket
      transitions     = optional list of { days = number, storage_class = string }
      expiration_days = optional number
  EOT
  type = list(object({
    id      = string
    enabled = bool
    prefix  = optional(string)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    expiration_days = optional(number)
  }))
  default = []
}
