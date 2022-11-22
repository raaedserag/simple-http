output "ecr_repo" {
  value = aws_ecr_repository.default_repo
}
output "app_environment_variables" {
  value = local.app_environment_variables
}