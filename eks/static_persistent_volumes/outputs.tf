output "persistent_volume_names" {
  description = "Names of the PersistentVolumes created."
  value       = keys(kubernetes_persistent_volume_v1.this)
}

output "storage_class_name" {
  description = "StorageClass the PVs use; set the workloads' PVC storageClassName to this."
  value       = var.storage_class_name
}
