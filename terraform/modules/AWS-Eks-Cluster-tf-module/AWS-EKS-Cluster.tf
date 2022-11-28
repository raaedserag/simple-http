# EKS Cluster Service Role
resource "aws_iam_role" "eks_cluster_service_role" {
  name = "EKS_Cluster_ServiceRole"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


# EKS Control Plane Security Group
resource "aws_security_group" "Eks_ControlPlane_SG" {
  name        = "Eks_Cluster_SG"
  vpc_id      = var.eks_vpc_id
  description = "allow All Connection to EKS Cluster"
}

resource "aws_security_group_rule" "Eks_ControlPlane_SG_recommended_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.Eks_ControlPlane_SG.id
}


# EKS Cluster Configuration
resource "aws_eks_cluster" "main_eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_service_role.arn

  vpc_config {
    security_group_ids     = []
    endpoint_public_access = true
    subnet_ids = concat(var.eks_private_subnets, var.eks_public_subnets)
  }
}
