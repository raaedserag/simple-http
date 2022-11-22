variable "repository_branch" {
  type        = string
  description = "The name of the repository branch"
}
variable "staging_environment_config" {
  type = object({
    name       = string
    image_name = string
  })
  description = "The configuration of staging environment"
}
