data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# exec auth (fresh token per call) - same reasoning as eks/addons/helm.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

# Statically-provisioned PersistentVolumes for pre-existing EBS volumes
# (see ebs/persistent_volumes), each pre-bound via claimRef to the exact PVC
# a workload will create (a StatefulSet volumeClaimTemplate PVC, or a chart's
# own PVC). When that PVC appears, it binds to this PV - and so to the
# existing data - instead of dynamically provisioning a new, empty volume.
#
# For the bind to happen the PVC must match: same storageClassName, an
# accessMode the PV offers, and a request <= capacity. So apply this BEFORE
# the workloads that create the PVCs.
#
# Reclaim policy is always Retain: deleting the PVC (helm uninstall, a
# namespace delete) or this PV object never deletes the EBS volume.
resource "kubernetes_persistent_volume_v1" "this" {
  for_each = var.volumes

  metadata {
    name = each.key
    labels = merge(var.labels, {
      "app.kubernetes.io/managed-by" = "terraform"
    })
  }

  spec {
    capacity = {
      storage = "${each.value.size_gb}Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = each.value.storage_class_name
    volume_mode                      = "Filesystem"

    claim_ref {
      namespace = each.value.claim_namespace
      name      = each.value.claim_name
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "topology.kubernetes.io/zone"
            operator = "In"
            values   = [each.value.availability_zone]
          }
        }
      }
    }

    persistent_volume_source {
      csi {
        driver        = "ebs.csi.aws.com"
        volume_handle = each.value.volume_id
        fs_type       = each.value.fs_type
      }
    }
  }
}
