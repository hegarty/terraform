output "namespace" {
  description = "Name of the namespace created."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "secret_names" {
  description = "Names of the Kubernetes Secrets created."
  value       = keys(kubernetes_secret_v1.this)
}
