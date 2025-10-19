variable "oidc_issuer" {
  type = string
} # e.g., https://oidc.eks.us-east-1.amazonaws.com/id/XYZ

variable "oidc_provider_arn" {
  type = string
} # arn:aws:iam::<acct>:oidc-provider/oidc.eks....../id/XYZ

variable "cluster_name" {
  type = string
} # eks-dev

variable "assume_role_policy" {
  type = string
}
