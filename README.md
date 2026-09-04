# KubeMind AI — Production-Grade AWS CI/CD with Terraform

This repository provisions a production-style CI/CD platform on AWS:

GitHub → CodePipeline → CodeBuild → Amazon ECR → CodeDeploy ECS Blue/Green → ECS Fargate → ALB → CloudWatch/SNS

> **Important:** Terraform provisions the AWS infrastructure. GitHub remains the source repository. The GitHub CodeConnections resource requires one-time authorization in the AWS console.

## Repository layout

```text
kubemind-ai-cicd/
├── application/
│   ├── app/
│   ├── Dockerfile
│   ├── buildspec.yml
│   ├── taskdef.json
│   └── appspec.yaml
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── security/
│   │   ├── ecr/
│   │   ├── alb/
│   │   ├── ecs/
│   │   ├── codedeploy/
│   │   ├── codebuild/
│   │   ├── codepipeline/
│   │   ├── monitoring/
│   │   └── iam/
│   └── environments/
│       ├── dev/
│       ├── staging/
│       └── production/
├── docs/
└── README.md
```

## Prerequisites

- Terraform >= 1.6
- AWS CLI v2
- Docker
- Git
- An AWS account with permission to create the resources in this lab
- A GitHub repository containing this project/application

## First deployment

Start with one environment, preferably `dev`.

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

After apply:

```bash
terraform output
```

Authorize the GitHub connection shown by `github_connection_arn`, then push the repository to GitHub.

## Important bootstrap behavior

The ECS service is provisioned with the current ECR `:latest` image so the platform can be created before the first pipeline run. The first successful pipeline then replaces the task definition with an immutable commit-tagged image.

## Cost warning

This lab creates resources that can incur charges, especially:
- NAT Gateways
- Application Load Balancer
- ECS Fargate
- CodeBuild
- CloudWatch logs
- S3

Destroy environments when you are finished:

```bash
terraform destroy
```

## Production hardening roadmap

Before using this as a real production platform:
- Move Terraform state to an encrypted S3 backend with locking.
- Use separate AWS accounts for dev/staging/prod.
- Use HTTPS with ACM and WAF.
- Add VPC endpoints and/or a NAT strategy appropriate to workload.
- Add image vulnerability gates.
- Add automated deployment alarms and application smoke tests.
- Use Secrets Manager/SSM instead of plaintext variables.
- Tighten IAM policies after observing exact API calls.
- Add CI/CD for Terraform itself with plan/apply approvals.
