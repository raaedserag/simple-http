variable "github_repository_name" {
  type        = string
  description = "The name of the GitHub repository"
}
variable "github_repository_branch" {
  type        = string
  description = "The name of the GitHub repository branch"
}
variable "staging_environment_config" {
  type = object({
    name       = string
    image_name = string
  })
  description = "The configuration of staging environment"
}
