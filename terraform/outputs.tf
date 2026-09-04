output "application_url" {
  value       = module.alb.application_url
  description = "ALB URL for the application."
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "github_connection_arn" {
  value       = module.codepipeline.github_connection_arn
  description = "Authorize this pending CodeConnections connection once in AWS."
}

output "codepipeline_name" {
  value = module.codepipeline.pipeline_name
}

output "codebuild_project_name" {
  value = module.codebuild.project_name
}

output "codedeploy_application_name" {
  value = module.codedeploy.application_name
}

output "codedeploy_deployment_group_name" {
  value = module.codedeploy.deployment_group_name
}

output "cloudwatch_log_group" {
  value = module.monitoring.log_group_name
}
