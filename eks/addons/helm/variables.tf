variable "cluster_name" {
  type = string
}

variable "release_name" {
  type        = string
  description = "Helm release name"
}

variable "repository" {
  type        = string
  description = "Helm chart repository URL"
}

variable "chart" {
  type        = string
  description = "Chart name"
}

variable "chart_version" {
  type    = string
  default = null
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "create_namespace" {
  type    = bool
  default = false
}

variable "timeout_seconds" {
  type    = number
  default = 600
}

variable "helm_values" {
  description = "Values map for the Helm chart"
  type        = any
}

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
