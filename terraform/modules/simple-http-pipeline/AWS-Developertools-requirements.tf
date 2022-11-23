data "aws_iam_role" "k8s_ops_role" {
  name = var.eks_cluster_config.ops_role_name
}
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "simple-http-pipeline-artifacts"
}
resource "aws_cloudwatch_log_group" "pipeline_log_group" {
  name = "/simple-http/pipeline"
}

resource "aws_iam_policy" "codepipeline_privileges" {
  name        = "simplehttp-codepipeline-priviliges"
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
            "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/node"
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
            "codebuild:StartBuild",
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
}

resource "aws_iam_policy_attachment" "codepipeline_privileges_attachment" {
  name       = "codepipeline_privileges_attachment"
  roles      = [data.aws_iam_role.k8s_ops_role.name]
  policy_arn = aws_iam_policy.codepipeline_privileges.arn
}