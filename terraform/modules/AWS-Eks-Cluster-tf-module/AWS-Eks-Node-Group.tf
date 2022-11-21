# EKS EC2 Managed Pod Node Service Role
resource "aws_iam_role" "eks_ec2_nodes_service_role" {
  name = "EKS_EC2_Node_ServiceRole"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}


resource "aws_key_pair" "nodes_key_pair" {
  key_name   = "eks-nodes-key-pair"
  public_key = var.eks_nodes_ssh_public_key
}

# EKS EC2 Managed Nodes Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.main_eks.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_ec2_nodes_service_role.arn
  subnet_ids = var.eks_private_subnets
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["t3.medium"]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }
  remote_access {
    ec2_ssh_key = aws_key_pair.nodes_key_pair.id
  }
}
