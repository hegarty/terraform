variable "cluster_name" {
  description = "EKS cluster to create the PersistentVolumes in."
  type        = string
}

variable "volumes" {
  description = "PersistentVolumes to create, keyed by PV name."
  type = map(object({
    volume_id          = string
    availability_zone  = string
    size_gb            = number
    claim_namespace    = string
    claim_name         = string
    storage_class_name = string
    fs_type            = optional(string, "ext4")
  }))
}

variable "labels" {
  description = "Labels applied to every PersistentVolume."
  type        = map(string)
  default     = {}
}
