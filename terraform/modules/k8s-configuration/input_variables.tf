variable "k8s_cluster_config" {
  type = object({
    endpoint               = string
    cluster_ca_certificate = string
    name                   = string
    arn                   = string
  })
  description = "The configuration of your EKS cluster."
}
variable "workernodes_role_arn" {
  type        = string
  description = "The ARN of the role that is used by the worker nodes."
}