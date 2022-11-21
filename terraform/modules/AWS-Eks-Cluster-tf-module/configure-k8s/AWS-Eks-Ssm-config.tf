# Enable OIDC provider for the EKS cluster
data "tls_certificate" "cluster_tls" {
  url = var.eks_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_tls.certificates[0].sha1_fingerprint]
  url             = var.eks_oidc_issuer_url
}

# Add EKS Service Account for AWS Parameter Store
resource "aws_iam_role" "aws-eks-ssm-role" {
  name = "aws-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.eks_oidc_issuer_url}:sub" = "system:serviceaccount:kube-system:aws-ssm-operator"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "allow-ssm-access"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ssm:Describe*",
            "ssm:Get*",
            "ssm:List*"
          ]
          Resource = "*"
        }
      ]
    })
  }
}
resource "kubernetes_service_account" "example" {
  metadata {
    name      = "aws-ssm-operator"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws-eks-ssm-role.arn
    }
  }
}

