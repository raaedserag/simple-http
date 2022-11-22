resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "simple-http-pipeline-artifacts"
}
resource "aws_cloudwatch_log_group" "pipeline_log_group" {
  name = "/simple-http/pipeline"
}

resource "aws_iam_role" "pipeline_role" {
  name = "Simplehttp-Codepipeline-Role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
          "codepipeline.amazonaws.com",
          "codebuild.amazonaws.com",
        ]
      }
    }]
    Version = "2012-10-17"
  })
  inline_policy {
    name = "codepipeline_access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "codecommit:*"
          ]
          Effect   = "Allow"
          Resource = "${data.aws_codecommit_repository.default_repo.arn}"
        },
        {
          Action = [
            "ecr:*"
          ]
          Effect = "Allow"
          Resource = [
            var.staging_environment_config.image_repository_arn,
            var.production_environment_config.image_repository_arn,
          ]
        },
        {
          Action = [
            "ecr:GetAuthorizationToken"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "s3:Put*",
            "s3:Get*"
          ]
          Effect = "Allow"
          Resource = [
            "${aws_s3_bucket.codepipeline_bucket.arn}",
            "${aws_s3_bucket.codepipeline_bucket.arn}/*"
          ]
        },
        {
          Action = [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}


