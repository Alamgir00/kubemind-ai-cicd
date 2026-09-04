output "alb_arn" { value = aws_lb.this.arn }
output "alb_dns_name" { value = aws_lb.this.dns_name }
output "application_url" { value = "http://${aws_lb.this.dns_name}" }
output "target_group_blue_arn" { value = aws_lb_target_group.blue.arn }
output "target_group_green_arn" { value = aws_lb_target_group.green.arn }
output "target_group_blue_name" { value = aws_lb_target_group.blue.name }
output "target_group_green_name" { value = aws_lb_target_group.green.name }
output "production_listener_arn" { value = aws_lb_listener.production.arn }
output "test_listener_arn" { value = aws_lb_listener.test.arn }

output "alb_arn_suffix" { value = aws_lb.this.arn_suffix }
