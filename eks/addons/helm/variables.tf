variable "cluster_name" {
  type = string
}

variable "helm_values" {
  description = "Values map for the HELM chart"
  type        = any
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "chart_version" {
  type    = string
  default = null
}

# variables.tf
variable "postrender_enabled" {
  type    = bool
  default = false
}

variable "postrender_binary_path" {
  type    = string
  default = null
}

variable "postrender_args" {
  type    = list(string)
  default = null
}

# (optional) provide a convenience string for a yq filter, if you want less quoting in TG
variable "postrender_yq_filter" {
  type    = string
  default = null
}
