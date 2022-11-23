output "simple_http_cluster" {
  value = aws_eks_cluster.main_eks
}
output "workernodes_role_arn" {
  value = aws_iam_role.eks_ec2_nodes_service_role.arn
}