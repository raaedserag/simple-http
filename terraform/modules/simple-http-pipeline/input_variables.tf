variable "code_commit_repo_name" {
  type        = string
  description = "The name of the CodeCommit repository"
}
variable "repository_branch" {
  type        = string
  description = "The name of the repository branch"
}
variable "staging_environment_config" {
  type = object({
    name                           = string
    image_repository_url           = string
    image_repository_arn           = string
    environment_variables          = map(string)
    deployment_name                = string
    simple_http_app_container_name = string
  })
  description = "The configuration of staging environment"
}
variable "production_environment_config" {
  type = object({
    name                           = string
    image_repository_url           = string
    image_repository_arn           = string
    environment_variables          = map(string)
    deployment_name                = string
    simple_http_app_container_name = string
  })
  description = "The configuration of staging environment"
}
