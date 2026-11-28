variable "cluster_name" {
  description = "EKS cluster to create the namespace and secrets in."
  type        = string
}

variable "namespace" {
  description = "Namespace to create (owned by this module)."
  type        = string
}

variable "namespace_labels" {
  description = "Labels for the namespace."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Kubernetes Secrets to create in the namespace, keyed by Secret name. Each Secrets Manager secret must contain a JSON object of string values."
  type = map(object({
    secrets_manager_secret_id = string
  }))
  default = {}
}
