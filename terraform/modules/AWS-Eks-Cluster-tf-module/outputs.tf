output "simple_http_cluster" {
  value = aws_eks_cluster.main_eks
}
output "simple_http_ecr_repo" {
  value = aws_ecr_repository.simple-http-repo
}