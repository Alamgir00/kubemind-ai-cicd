# KubeMind AI — Hands-On Implementation Checklist

## Phase 0 — Local prerequisites

- [ ] AWS CLI installed
- [ ] Terraform >= 1.6 installed
- [ ] Docker installed
- [ ] Git installed
- [ ] `aws sts get-caller-identity` succeeds
- [ ] GitHub repository created

## Phase 1 — Application

From the repository root:

```bash
cd application
docker build -t kubemind-cicd:local .
docker run --rm -p 8080:80 kubemind-cicd:local
```

Open `http://localhost:8080`.

- [ ] Application loads
- [ ] Container health check passes
- [ ] Version 1.0 visible

## Phase 2 — Terraform dev

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Set:

```hcl
github_owner = "YOUR_GITHUB_OWNER"
github_repo  = "YOUR_GITHUB_REPO"
```

Then:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

- [ ] VPC created
- [ ] Private/public subnets created
- [ ] NAT gateway(s) created
- [ ] Security groups created
- [ ] ECR created
- [ ] ALB created
- [ ] ECS cluster/service created
- [ ] CodeDeploy application/group created
- [ ] CodeBuild project created
- [ ] CodePipeline created
- [ ] CloudWatch logs/alarm/SNS created

## Phase 3 — GitHub authorization

```bash
terraform output github_connection_arn
```

Authorize the pending GitHub connection in AWS CodeConnections.

- [ ] Connection status is AVAILABLE

## Phase 4 — First pipeline

Push the repository:

```bash
git add .
git commit -m "Initial CI/CD application"
git push origin main
```

Watch:

```text
Source → Build → Deploy
```

- [ ] Source succeeds
- [ ] CodeBuild succeeds
- [ ] Docker image pushed to ECR
- [ ] imageDetail.json generated
- [ ] CodeDeploy creates green task set
- [ ] Green health checks pass
- [ ] Traffic shifts
- [ ] Old blue task set terminates after wait
- [ ] Application is reachable

## Phase 5 — Release exercise

Change `application/app/index.html` from Version 1.0 to Version 2.0.

Push a commit.

- [ ] New image tag equals commit SHA
- [ ] ECR contains immutable commit-tagged image
- [ ] Pipeline deploys automatically
- [ ] Browser shows Version 2.0

## Phase 6 — Failure exercise

Introduce a deliberate Docker/build failure.

- [ ] CodeBuild fails
- [ ] Deploy stage does not run
- [ ] Previous application remains healthy

Fix the issue and push again.

- [ ] Pipeline recovers

## Phase 7 — Rollback exercise

Deploy a bad application revision that passes Docker build but fails application health.

- [ ] Green target becomes unhealthy
- [ ] Deployment fails/stops
- [ ] Production remains on the last good release or rolls back according to the configured deployment/alarm behavior

## Phase 8 — Production hardening

- [ ] S3 remote Terraform state
- [ ] State locking
- [ ] KMS
- [ ] HTTPS/ACM
- [ ] WAF
- [ ] VPC endpoints where appropriate
- [ ] Secrets Manager/SSM
- [ ] image vulnerability gate
- [ ] deployment alarms
- [ ] smoke tests
- [ ] least-privilege IAM review
- [ ] dev/staging/prod account separation
- [ ] Terraform CI/CD
- [ ] manual production approval
- [ ] disaster recovery test
