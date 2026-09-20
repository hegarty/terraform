variable "name" {
  type = string
}

variable "image_tag_mutability" {
  type = string
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "lifecycle_policy" {
  description = "ECR lifecycle policy JSON (jsonencode(...)), or null to skip and let images accumulate indefinitely"
  type        = string
  default     = null
}
