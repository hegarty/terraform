variable "quotas" {
  description = "List of service-quota limits to set"
  type = list(object({
    quota_code   = string
    service_code = string
    limit        = number
    common_name  = optional(string)
  }))
}
