data "aws_codecommit_repository" "default_repo" {
  repository_name = "simple-http-repo"
}
resource "aws_iam_role" "codecommit_events_rule_role" {
  name = "simple-http-codecommit-events-rule-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
          "events.amazonaws.com"
        ]
      }
    }]
    Version = "2012-10-17"
  })
  inline_policy {
    name = "trigger_codepipeline"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "codepipeline:StartPipelineExecution"
          ]
          Effect   = "Allow"
          Resource = aws_codepipeline.default_pipeline.arn
        }
      ]
    })
  }
}
resource "aws_cloudwatch_event_rule" "codecommit_trigger" {
  name_prefix = "simple-http-codecommit-trigger"
  description = "Trigger codepipeline on codecommit push"
  role_arn    = aws_iam_role.codecommit_events_rule_role.arn
  event_pattern = jsonencode({
    source      = ["aws.codecommit"]
    detail-type = ["CodeCommit Repository State Change"]
    resources   = [data.aws_codecommit_repository.default_repo.arn]
    detail = {
      event         = ["referenceCreated", "referenceUpdated"]
      referenceType = ["branch"]
      referenceName = [var.repository_branch]
    }
  })
}

resource "aws_cloudwatch_event_target" "code_pipeline_trigger_target" {
  rule      = aws_cloudwatch_event_rule.codecommit_trigger.name
  target_id = "simple-http-codepipeline-trigger"
  arn       = aws_codepipeline.default_pipeline.arn
  role_arn  = aws_iam_role.codecommit_events_rule_role.arn
}
