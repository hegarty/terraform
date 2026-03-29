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
