resource "aws_codepipeline" "default_pipeline" {
  name     = "simple-http-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }


  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = data.aws_codecommit_repository.default_repo.repository_name
        BranchName           = var.repository_branch
        PollForSourceChanges = "false"
      }
    }
  }
  stage {
    name = "Staging"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.staging_build.name
      }
    }
    action {
      name            = "Build"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.staging_test.name
      }
    }
    # action {
    #   name            = "Build"
    #   category        = "Build"
    #   owner           = "AWS"
    #   provider        = "CodeBuild"
    #   input_artifacts = ["source_output"]
    #   version         = "1"
    #   configuration = {
    #     ProjectName = aws_codebuild_project.staging_build.name
    #   }
    # }
  }
}
