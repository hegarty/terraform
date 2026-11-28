variable "cluster_name" {
  description = "EKS cluster to create the PersistentVolumes in."
  type        = string
}

variable "volumes" {
  description = "PersistentVolumes to create, keyed by PV name."
  type = map(object({
    volume_id         = string
    availability_zone = string
    size_gb           = number
    claim_namespace   = string
    claim_name        = string
    # Defaults to var.storage_class_name (the module's no-provisioner class).
    storage_class_name = optional(string)
    fs_type            = optional(string, "ext4")
  }))
}

variable "labels" {
  description = "Labels applied to every PersistentVolume."
  type        = map(string)
  default     = {}
}

variable "storage_class_name" {
  description = "StorageClass for the PVs (and the PVCs that must bind to them). Must be a class that cannot dynamically provision - see main.tf."
  type        = string
  default     = "ebs-static"
}

variable "create_storage_class" {
  description = "Create storage_class_name here as a kubernetes.io/no-provisioner class. Set false only if it is managed elsewhere."
  type        = bool
  default     = true
}
