locals {
  environment_variables = merge(
    var.staging_environment_config.environment_variables,
    {
      AWS_DEFAULT_REGION = data.aws_region.default.name
      AWS_ACCOUNT_ID     = data.aws_caller_identity.default.account_id
      IMAGE_NAME         = var.staging_environment_config.image_repository_url
    }
  )
}
resource "aws_codebuild_project" "build_images" {
  name          = "build-${var.staging_environment_config.name}-simple-http"
  description   = "Builds the Docker images for the simple-http application"
  build_timeout = "5"
  service_role  = aws_iam_role.pipeline_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "devops/buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:4.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    dynamic "environment_variable" {
      for_each = local.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.key
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.pipeline_log_group.name
      stream_name = "${var.staging_environment_config.name}/build-images"
    }
  }
}
