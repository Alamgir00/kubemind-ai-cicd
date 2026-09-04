variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "ecr_repository_url" { type = string }
variable "ecr_repository_arn" { type = string }
variable "log_group_name" { type = string }
variable "service_role_arn" { type = string }
variable "artifact_bucket_name" { type = string }
variable "source_version" { type = string }

variable "ecs_task_execution_role_arn" { type = string }
