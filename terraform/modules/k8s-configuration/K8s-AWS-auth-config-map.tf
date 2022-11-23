resource "aws_iam_role" "ops_role" {
  name = "Simplehttp-Codepipeline-Role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
          "codepipeline.amazonaws.com",
          "codebuild.amazonaws.com",
        ]
      }
    }]
    Version = "2012-10-17"
  })
  inline_policy {
    name = "eks_access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "eks:DescribeCluster"
          ],
          Effect   = "Allow",
          Resource = "${var.k8s_cluster_config.arn}"
        }
      ]
    })
  }
}
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    "mapRoles" = <<EOT
  - rolearn: ${var.workernodes_role_arn}
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: ${aws_iam_role.ops_role.arn}
    username: codebuild
    groups:
      - system:masters
  EOT

  }


}

resource "kubernetes_cluster_role_binding" "deployment_role_cluster_admin_binding" {
  metadata {
    name = "ops-role-cluster-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "codebuild"
    api_group = "rbac.authorization.k8s.io"
  }
}
