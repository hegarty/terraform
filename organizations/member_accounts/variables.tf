variable "member_accounts" {
  description = "List of accounts to create. Each needs name, email, parent_ou_id, environment, and cidr (list(string))."
  type = list(object({
    name         = string
    email        = string
    parent_ou_id = string
    environment  = string
    cidr         = list(string)
  }))
}
