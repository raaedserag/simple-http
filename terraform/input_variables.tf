variable "vpc_cidr_block" {
  description = "VPC CIDR Block. eg: 10.0.0.0/16"
  type        = string
}
variable "subnet_public_a_cidr_block" {
  description = "CIDR Block for public subnet of AZ a"
  type        = string
}
variable "subnet_public_b_cidr_block" {
  description = "CIDR Block for public subnet of AZ b"
  type        = string
}
variable "subnet_private_a_cidr_block" {
  description = "CIDR Block for private subnet of AZ a"
  type        = string
}
variable "subnet_private_b_cidr_block" {
  description = "CIDR Block for private subnet of AZ b"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name for  EKS cluster"
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
}
variable "version_number" {
  description = "The version of the application."
  type        = string
}
variable "rds_user_name" {
  description = "The name of the RDS user."
  type        = string
}
variable "rds_user_password" {
  description = "The password of the RDS user."
  type        = string
}
variable "rds_db_name" {
  description = "The name of the initial RDS database."
  type        = string
}
variable "app_static_environment_variables" {
  description = "The static environment variables for the application."
  type        = map(string)
}
variable "app_replicas_count" {
  description = "The number of replicas for the application."
  type        = number
}
variable "github_repository_name" {
  description = "The name of the GitHub repository."
  type        = string
}
variable "github_repository_branch" {
  description = "The name of the GitHub repository branch."
  type        = string
}