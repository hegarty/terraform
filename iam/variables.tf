variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "policy_description" {
  type = string
}

variable "policy" {
  type    = string
  default = null
}

variable "aws_managed_policies" {
  type    = list(any)
  default = []
}
