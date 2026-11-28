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

# A namespace plus Kubernetes Secrets materialised from AWS Secrets Manager.
#
# For clusters that are rebuilt routinely: any Secret created by hand with
# `kubectl create secret` is lost on every rebuild, and whatever needs it
# (e.g. a chart's `existingSecret`) then fails to start. Keeping the value in
# Secrets Manager (retained across rebuilds) and re-creating the Secret here
# on every `up` makes the rebuild fully unattended.
#
# This module OWNS the namespace: create it here, before any Helm release
# that installs into it (those should use create_namespace = false, or rely
# on Helm's create-if-missing), and make those releases depend on this unit
# so a teardown removes them before the namespace is deleted.
#
# Each Secrets Manager secret must hold a JSON object; its keys become the
# Kubernetes Secret's data keys. Values pass through Terraform state, which
# is the same trust boundary as the Secret itself.
resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.namespace
    labels = var.namespace_labels
  }
}

data "aws_secretsmanager_secret_version" "this" {
  for_each  = var.secrets
  secret_id = each.value.secrets_manager_secret_id
}

resource "kubernetes_secret_v1" "this" {
  for_each = var.secrets

  metadata {
    name      = each.key
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  type = "Opaque"
  data = jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string)
}
