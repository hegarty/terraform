data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
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
}
