# Architecture

## Traffic and delivery flow

```text
Developer
   |
   | git push
   v
GitHub
   |
   v
AWS CodePipeline
   |
   +--> Source artifact (S3)
   |
   v
AWS CodeBuild
   |
   +--> validate application
   +--> Docker build
   +--> ECR push
   +--> imageDetail.json
   |
   v
CodeDeployToECS
   |
   +--> register task definition
   +--> create green task set
   +--> health-check green
   +--> shift ALB traffic
   +--> terminate blue after wait
   |
   v
ECS Fargate
   |
   v
Application Load Balancer
   |
   v
Users

Observability:
ECS/CodeBuild -> CloudWatch Logs
ALB -> CloudWatch metrics -> Alarm -> SNS
```

## Network

- Two public subnets host the ALB and NAT gateways.
- Two private subnets host ECS tasks.
- ECS security group accepts application traffic only from the ALB security group.
- NAT gateways provide outbound Internet access for private tasks/build-time dependencies.

## Terraform boundaries

Each module owns one concern:

- `vpc`: networking
- `security`: security groups
- `ecr`: container registry
- `alb`: load balancer/listeners/target groups
- `ecs`: cluster/task/service
- `codedeploy`: blue/green deployment
- `codebuild`: build project
- `codepipeline`: pipeline, GitHub connection, artifact bucket
- `monitoring`: logs, alarm, SNS
- `iam`: service roles and policies
