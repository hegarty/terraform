variable "cluster_name" {
  type        = string
  description = "EKS cluster name Karpenter manages nodes for"
}

variable "cluster_arn" {
  type        = string
  description = "ARN of the EKS cluster"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "service_account_name" {
  type    = string
  default = "karpenter"
}

variable "controller_role_name" {
  type        = string
  description = "Name for the Karpenter controller IAM role"
}

variable "node_role_name" {
  type        = string
  description = "Name for the IAM role assumed by Karpenter-launched EC2 nodes"
}

variable "node_iam_managed_policies" {
  type        = list(string)
  description = "AWS-managed policies attached to Karpenter-launched nodes"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}

variable "interruption_queue_name" {
  type        = string
  description = "Name for the SQS queue Karpenter consumes spot interruption / instance state-change events from"
}

variable "message_retention_seconds" {
  type    = number
  default = 300
}

variable "tags" {
  type    = map(string)
  default = {}
}
