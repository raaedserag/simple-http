
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
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "IMAGE_NAME"
      value = var.staging_environment_config.image_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.pipeline_log_group.name
      stream_name = "${var.staging_environment_config.name}/build-images"
    }
  }
}
