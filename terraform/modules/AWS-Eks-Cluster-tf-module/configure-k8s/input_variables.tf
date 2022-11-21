variable "eks_oidc_issuer_url" {
  type        = string
  description = "OIDC issuer URL for the EKS cluster"
}
variable "eks_cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}
variable "eks_cluster_certificate_authority" {
  type        = string
  description = "EKS cluster certificate authority"
}
variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID"
}