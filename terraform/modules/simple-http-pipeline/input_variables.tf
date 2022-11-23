variable "code_commit_repo_name" {
  type        = string
  description = "The name of the CodeCommit repository"
}
variable "repository_branch" {
  type        = string
  description = "The name of the repository branch"
}
variable "eks_cluster_config" {
  type = object({
    name = string
    arn  = string
  })
  description = "The configuration of the EKS cluster"
}
variable "staging_environment_config" {
  type = object({
    name                           = string
    image_repository_url           = string
    image_repository_arn           = string
    eks_namespace                  = string
    deployment_name                = string
    simple_http_app_container_name = string
    environment_variables          = map(string)
  })
  description = "The configuration of staging environment"
}
variable "production_environment_config" {
  type = object({
    name                           = string
    image_repository_url           = string
    image_repository_arn           = string
    eks_namespace                  = string
    deployment_name                = string
    simple_http_app_container_name = string
    environment_variables          = map(string)
  })
  description = "The configuration of staging environment"
}
