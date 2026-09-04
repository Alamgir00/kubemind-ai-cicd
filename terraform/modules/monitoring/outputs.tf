output "log_group_name" { value = aws_cloudwatch_log_group.ecs.name }
output "log_group_arn" { value = aws_cloudwatch_log_group.ecs.arn }
output "codebuild_log_group_name" { value = aws_cloudwatch_log_group.codebuild.name }
output "sns_topic_arn" { value = aws_sns_topic.alerts.arn }
output "alb_5xx_alarm_name" { value = aws_cloudwatch_metric_alarm.alb_5xx.alarm_name }
