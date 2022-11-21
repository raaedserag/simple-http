variable "vpc_cidr_block" {
  description = "VPC CIDR Block. eg: 10.0.0.0/16"
  type        = string
}

variable "subnet_public_a_cidr_block" {
  description = "CIDR Block for public subnet of AZ a"
  type        = string
}

variable "subnet_private_a_cidr_block" {
  description = "CIDR Block for private subnet of AZ a"
  type        = string
}

variable "subnet_public_b_cidr_block" {
  description = "CIDR Block for public subnet of AZ b"
  type        = string
}

variable "subnet_private_b_cidr_block" {
  description = "CIDR Block for private subnet of AZ b"
  type        = string
}
