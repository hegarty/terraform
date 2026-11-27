data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

# A static `token = data.aws_eks_cluster_auth.this.token` is a single EKS auth
# token (valid 15 minutes) frozen into the plan/state at read time - fine for
# a quick apply, but a long-running helm_release (or any delay between
# `plan -out=` and `apply`) can outlive it, failing mid-apply with "the
# server has asked for the client to provide credentials". `exec` instead
# re-invokes `aws eks get-token` fresh every time the provider actually
# needs to authenticate, so it can never go stale mid-operation.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

resource "helm_release" "this" {
  name       = var.release_name
  namespace  = var.namespace
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  create_namespace = var.create_namespace
  atomic           = true
  wait             = true
  timeout          = var.timeout_seconds

  # all values come from Terragrunt
  values = [yamlencode(var.helm_values)]

  dynamic "postrender" {
    for_each = var.postrender_enabled ? [1] : []
    content {
      binary_path = var.postrender_binary_path
      args        = var.postrender_args
    }
  }
}
