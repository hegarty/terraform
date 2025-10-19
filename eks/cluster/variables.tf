variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "iam_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "security_groups" {
  type = list(string)
}

variable "endpoint_public_access" {
  type = bool
}

variable "endpoint_private_access" {
  type = bool
}

variable "public_access_cidrs" {
  type = list
}

variable "authentication_mode" {
  type = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  type = bool
}
