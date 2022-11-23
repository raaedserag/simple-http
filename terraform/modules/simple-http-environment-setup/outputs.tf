output "ecr_repo" {
  value = aws_ecr_repository.default_repo
}
output "app_environment_variables" {
  value = local.app_environment_variables
}
output "eks_namespace" {
  value = kubernetes_namespace.current_namespace.metadata.0.name
}
output "app_deployment_name" {
  value = kubernetes_deployment.simple-http-deployment.metadata.0.name
}
output "simple_http_app_container_name" {
  value = kubernetes_deployment.simple-http-deployment.spec.0.template.0.spec.0.container.0.name
}
