module "platform" {
  source = "../.."

  aws_region                = var.aws_region
  project_name              = var.project_name
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  allowed_ingress_cidrs     = var.allowed_ingress_cidrs
  container_port            = var.container_port
  desired_count             = var.desired_count
  cpu                       = var.cpu
  memory                    = var.memory
  github_owner              = var.github_owner
  github_repo               = var.github_repo
  github_branch             = var.github_branch
  alert_email               = var.alert_email
  enable_nat_gateway_per_az = var.enable_nat_gateway_per_az
  log_retention_days        = var.log_retention_days
  tags                      = var.tags
}

output "application_url" { value = module.platform.application_url }
output "github_connection_arn" { value = module.platform.github_connection_arn }
output "codepipeline_name" { value = module.platform.codepipeline_name }
output "ecr_repository_url" { value = module.platform.ecr_repository_url }
