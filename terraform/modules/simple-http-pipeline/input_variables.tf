variable "code_commit_repo_name"{
  type = string
  description = "The name of the CodeCommit repository"
}
variable "repository_branch" {
  type        = string
  description = "The name of the repository branch"
}
variable "staging_environment_config" {
  type = object({
    name                 = string
    image_repository_url = string
    image_repository_arn = string
  })
  description = "The configuration of staging environment"
}
variable "production_environment_config" {
  type = object({
    name                 = string
    image_repository_url = string
    image_repository_arn = string
  })
  description = "The configuration of staging environment"
}
