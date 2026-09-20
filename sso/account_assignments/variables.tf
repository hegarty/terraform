variable "assignments" {
  type = list(object({
    permission_set_name = string
    group_name          = string
    account_id          = string
  }))
}
