
variable "eks_cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_nodes_ssh_public_key" {
  type        = string
  description = "SSH public key to use for EKS nodes"
}
variable "eks_vpc_id" {
  type        = string
  description = "VPC ID to use for EKS cluster"
}
variable "eks_private_subnets"{
  type = list(string)
  description = "List of private subnets to use for the EKS cluster"
}
variable "eks_public_subnets"{
  type = list(string)
  description = "List of public subnets to use for the EKS cluster"
}