variable "cluster_name" {
  type = string
}

variable "principal_arn" {
  type = string
}

variable "policy_arn" {
  type = string
}

variable "access_scope_type" {
  type = string
}

variable "node_type" {
  type = string
  default = null
}

variable "kubernetes_groups" {
  type = list
  default = []
}
