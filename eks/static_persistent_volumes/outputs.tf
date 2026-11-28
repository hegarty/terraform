output "persistent_volume_names" {
  description = "Names of the PersistentVolumes created."
  value       = keys(kubernetes_persistent_volume_v1.this)
}
