locals {
  staging_environment_variables = merge(
    var.staging_environment_config.environment_variables,
    {
      AWS_DEFAULT_REGION         = data.aws_region.current.name
      AWS_ACCOUNT_ID             = data.aws_caller_identity.current.account_id
      IMAGE_NAME                 = var.staging_environment_config.image_repository_url
      DEPLOYMENT_NAME            = var.staging_environment_config.deployment_name
      SIMPLE_HTTP_CONTAINER_NAME = var.staging_environment_config.simple_http_app_container_name
      EKS_CLUSTER_NAME           = var.eks_cluster_config.name
      EKS_NAMESPACE              = var.staging_environment_config.eks_namespace
    }
  )
}

resource "aws_codebuild_project" "staging_build" {
  name          = "build-${var.staging_environment_config.name}-simple-http"
  description   = "Build staging images for simple-http application"
  build_timeout = "5"
  service_role  = data.aws_iam_role.k8s_ops_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "devops/build.buildspec.yml"
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
      for_each = local.staging_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.pipeline_log_group.name
      stream_name = "${var.staging_environment_config.name}/build"
    }
  }
}
resource "aws_codebuild_project" "staging_test" {
  name          = "testing-${var.staging_environment_config.name}-simple-http"
  description   = "Testing staging images for simple-http application"
  build_timeout = "5"
  service_role  = data.aws_iam_role.k8s_ops_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "devops/testing.buildspec.yml"
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
      for_each = local.staging_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.pipeline_log_group.name
      stream_name = "${var.staging_environment_config.name}/testing"
    }
  }
}
resource "aws_codebuild_project" "staging_deploy" {
  name          = "deploy-${var.staging_environment_config.name}-simple-http"
  description   = "Deploy staging images for simple-http application"
  build_timeout = "5"
  service_role  = data.aws_iam_role.k8s_ops_role.arn
  source {
    type      = "CODEPIPELINE"
    buildspec = "devops/deploy.buildspec.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image                       = "aws/codebuild/standard:4.0"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    dynamic "environment_variable" {
      for_each = local.staging_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.pipeline_log_group.name
      stream_name = "${var.staging_environment_config.name}/deploy"
    }
  }
}
