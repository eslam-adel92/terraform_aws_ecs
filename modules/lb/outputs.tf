output "project_name" {
  value = var.project_name
}
output "lb_arn" {
  value = aws_alb.main.arn
}
output "listener_arn" {
  value = aws_alb_listener.front_end.arn
}
output "sg_id" {
  value = aws_security_group.lb.id
}
output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "alb_hostname" {
  value = aws_alb.main.dns_name
}
output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.app.arn
}
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}