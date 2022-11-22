variable "k8s_cluster_config" {
  type = object({
    endpoint               = string
    cluster_ca_certificate = string
    name                   = string
  })
  description = "The configuration of your EKS cluster."
}

variable "app_name" {
  type        = string
  description = "The name of the application."
}
variable "app_static_environment_variables" {
  type = map(string)
  description = "And additional static environment variables for the application."
}
variable "version_number" {
  type        = string
  description = "The version of the application."
}
variable "environment" {
  type        = string
  description = "The environment of the application."
}

variable "rds_config" {
  type = object({
    db_user         = string
    db_password     = string
    initial_db_name = string
    vpc_id          = string
    subnets         = list(string)
    allowed_inbound_cidr_blocks = list(string)
  })
  description = "The configuration of the RDS database."
}
variable "app_replicas_count" {
  type        = number
  description = "The number of replicas for the application."
}