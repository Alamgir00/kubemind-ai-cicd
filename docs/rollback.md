# Rollback Runbook

## Automatic rollback

The CodeDeploy deployment group is configured to roll back on deployment failure and deployment stop-on-alarm.

## Manual rollback concept

Blue/green maintains the old environment during the deployment wait period.

```text
BLUE = current production
GREEN = new release

          health check
BLUE ----------------------> GREEN
                              |
                              v
                         traffic shift
```

If the green version fails validation before traffic shift, production remains on blue.

If a deployment has shifted traffic and an alarm triggers, CodeDeploy can stop/roll back according to the configured deployment and alarm behavior.

## Application rollback

The safest application rollback is normally to redeploy the last known-good Git commit:

```bash
git revert <bad-commit>
git push origin main
```

This creates a new pipeline execution and preserves an auditable Git history.

## Emergency validation

1. Check CodeDeploy deployment status.
2. Check ALB target health.
3. Check ECS task health.
4. Check CloudWatch logs.
5. Identify the last known-good ECR image digest.
6. Revert the Git change and redeploy.
7. Confirm application health through the ALB.

Do not manually edit the ECS service task definition in production when Terraform/CodePipeline owns the delivery path.
