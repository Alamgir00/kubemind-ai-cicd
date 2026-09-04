# Deployment Runbook

## 1. Prepare AWS

```bash
aws sts get-caller-identity
aws configure get region
```

Use one region consistently.

## 2. Create the GitHub repository

Push the contents of `application/` and this Terraform repository to GitHub.

## 3. Deploy dev

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit GitHub owner/repo and other settings.

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

## 4. Authorize GitHub

```bash
terraform output github_connection_arn
```

Open AWS CodeConnections and complete the pending GitHub authorization.

## 5. Trigger the pipeline

Push a commit to the configured branch:

```bash
git add .
git commit -m "Release application"
git push origin main
```

## 6. Verify

```bash
terraform output application_url
```

Check:
- CodePipeline Source = Succeeded
- CodeBuild = Succeeded
- ECR contains the new image
- CodeDeploy deployment = Succeeded
- ECS service has healthy tasks
- ALB target group has healthy targets

## 7. Destroy the lab

```bash
terraform destroy
```

Destroy dev before staging/production if this is a training account.

## Production state

Use an S3 backend with encryption and Terraform's S3 lockfile mechanism before team use. Keep each environment in a separate state key.
