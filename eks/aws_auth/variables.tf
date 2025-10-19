variable "kubernetes_provider" {
  type = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca" {
  description = "Base64-encoded cluster CA"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "map_roles" {
  description = "List of IAM roles to grant access"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}
