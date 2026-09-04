data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "vpc" {
  source = "./modules/vpc"

  project_name              = var.project_name
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  enable_nat_gateway_per_az = var.enable_nat_gateway_per_az
}

module "security" {
  source = "./modules/security"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  container_port        = var.container_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.project_name
}

locals {
  artifact_bucket_name = "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}"
}

module "iam" {
  source = "./modules/iam"

  project_name        = var.project_name
  environment         = var.environment
  aws_region          = var.aws_region
  account_id          = data.aws_caller_identity.current.account_id
  ecr_repository_arn  = module.ecr.repository_arn
  artifact_bucket_arn = "arn:aws:s3:::${local.artifact_bucket_name}"
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  container_port    = var.container_port
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = var.log_retention_days
  alert_email        = var.alert_email
  alb_arn_suffix     = module.alb.alb_arn_suffix
}

module "ecs" {
  source = "./modules/ecs"

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  private_subnet_ids      = module.vpc.private_subnet_ids
  security_group_id       = module.security.ecs_security_group_id
  target_group_blue_arn   = module.alb.target_group_blue_arn
  desired_count           = var.desired_count
  cpu                     = var.cpu
  memory                  = var.memory
  container_port          = var.container_port
  ecr_repository_url      = module.ecr.repository_url
  task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  log_group_name          = module.monitoring.log_group_name
}

module "codedeploy" {
  source = "./modules/codedeploy"

  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  target_group_blue_name  = module.alb.target_group_blue_name
  target_group_green_name = module.alb.target_group_green_name
  production_listener_arn = module.alb.production_listener_arn
  test_listener_arn       = module.alb.test_listener_arn
  codedeploy_role_arn     = module.iam.codedeploy_role_arn
  alarm_names             = [module.monitoring.alb_5xx_alarm_name]
}

module "codebuild" {
  source = "./modules/codebuild"

  project_name                = var.project_name
  environment                 = var.environment
  aws_region                  = var.aws_region
  ecr_repository_url          = module.ecr.repository_url
  ecr_repository_arn          = module.ecr.repository_arn
  log_group_name              = module.monitoring.codebuild_log_group_name
  service_role_arn            = module.iam.codebuild_role_arn
  artifact_bucket_name        = local.artifact_bucket_name
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  source_version              = var.github_branch
}

module "codepipeline" {
  source = "./modules/codepipeline"

  project_name                = var.project_name
  environment                 = var.environment
  github_owner                = var.github_owner
  github_repo                 = var.github_repo
  github_branch               = var.github_branch
  codebuild_project_name      = module.codebuild.project_name
  codedeploy_application_name = module.codedeploy.application_name
  codedeploy_deployment_group = module.codedeploy.deployment_group_name
  codepipeline_role_arn       = module.iam.codepipeline_role_arn
  artifact_bucket_name        = local.artifact_bucket_name
}

