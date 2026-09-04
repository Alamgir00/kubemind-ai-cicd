# Troubleshooting

## Pipeline does not start

Check:
1. GitHub connection status is `AVAILABLE`.
2. Repository and branch match `terraform.tfvars`.
3. CodePipeline source action has the correct FullRepositoryId.
4. A new commit was pushed after the connection was authorized.

## CodeBuild fails during Docker build

Check:
- CodeBuild privileged mode is enabled.
- Dockerfile exists under `application/Dockerfile`.
- Buildspec path is `application/buildspec.yml`.
- ECR repository exists.
- CodeBuild role can push to ECR.

## CodeBuild cannot push to ECR

Check IAM for:
- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:InitiateLayerUpload`
- `ecr:UploadLayerPart`
- `ecr:CompleteLayerUpload`
- `ecr:PutImage`

## ECS tasks are unhealthy

Check:
- ECS task is in private subnet.
- NAT gateway/route is working.
- ECS SG allows port 80 from ALB SG.
- Container listens on port 80.
- Container health check returns success.
- ALB target group health check path is `/`.

## CodeDeploy fails

Check:
- ECS service uses `CODE_DEPLOY` deployment controller.
- Blue and green target groups exist.
- Production and test listeners exist.
- AppSpec container name is `kubemind-app`.
- AppSpec port is `80`.
- `imageDetail.json` contains the correct container name and ECR URI.
- CodeDeploy role can pass the ECS task execution role.

## Pipeline deploy action cannot register a task definition

Check CodePipeline role:
- `ecs:RegisterTaskDefinition`
- `iam:PassRole` for the ECS task execution role
- CodeDeploy application/deployment group permissions

## No email from SNS

SNS email subscriptions require confirmation. Check the inbox and confirm the subscription.

## Cost investigation

The most common high-cost training resources are NAT gateways, ALB, Fargate and CodeBuild. Destroy unused environments.
