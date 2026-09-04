
resource "aws_codebuild_project" "this" {
  name         = "${var.project_name}-${var.environment}"
  service_role = var.service_role_arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "application/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URI"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = split("/", var.ecr_repository_url)[1]
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = "kubemind-app"
    }

    environment_variable {
      name  = "ECS_TASK_EXECUTION_ROLE_ARN"
      value = var.ecs_task_execution_role_arn
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.log_group_name
      stream_name = "build"
    }
  }
}
