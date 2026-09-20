variable "permission_sets" {
  type = list(object({
    permission_set_name          = string
    permission_set_description   = string
    relay_state_region           = string
    session_duration             = string
    managed_policy_arn           = optional(list(string))
    customer_managed_policy_name = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
