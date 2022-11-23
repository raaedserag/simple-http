terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.0"
    }
  }
}
provider "kubernetes" {
  host                   = var.k8s_cluster_config.endpoint
  cluster_ca_certificate = base64decode(var.k8s_cluster_config.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.k8s_cluster_config.name]
    command     = "aws"
  }
  ignore_annotations = [
    "^service\\.beta\\.kubernetes\\.io\\/aws-load-balancer.*",
    "cni\\.projectcalico\\.org\\/podIP",
    "cni\\.projectcalico\\.org\\/podIPs",
  ]
}
