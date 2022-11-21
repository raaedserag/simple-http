terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }

  required_version = ">= 1.2.4"
}

module "k8s_configuration" {
  source              = "./configure-k8s"
  eks_oidc_issuer_url = aws_eks_cluster.main_eks.identity[0].oidc[0].issuer
  eks_cluster_endpoint = aws_eks_cluster.main_eks.endpoint
  eks_cluster_certificate_authority = aws_eks_cluster.main_eks.certificate_authority[0].data
  eks_cluster_id = aws_eks_cluster.main_eks.id
}
