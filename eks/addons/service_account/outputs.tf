output "arn" {
  value = kubernetes_service_account.this.metadata[0].annotations
}
