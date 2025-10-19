variable "cluster_name" {
  type = string
}

variable "addon_name" {
  type = string
}

variable "addon_version" {
  type = string
  default = null
}

variable "service_role_arn" {
  type = string
}

variable "resolve_conflicts_on_update" {
  type = string
}

variable "configuration_values" {
  type = string
  default = null
}

variable "tags" {
  type = map(string)
}
