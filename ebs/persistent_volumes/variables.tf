variable "volumes" {
  description = "Persistent EBS volumes, keyed by a stable name (also used as the Name tag)."
  type = map(object({
    availability_zone = string
    size_gb           = number
    type              = optional(string, "gp3")
    iops              = optional(number, 3000)
    throughput        = optional(number, 125)
    # Defaults to encrypted for new volumes. Set false only when adopting an
    # existing unencrypted volume (changing it forces replacement).
    encrypted  = optional(bool, true)
    kms_key_id = optional(string)
    tags       = optional(map(string), {})
  }))
}

variable "tags" {
  description = "Tags applied to every volume."
  type        = map(string)
  default     = {}
}
