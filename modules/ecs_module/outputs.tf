output "project_name" {
  value = var.project_name
}

output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster"
  value       = aws_ecs_cluster.ecs-cluster.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS Cluster"
  value       = aws_ecs_cluster.ecs-cluster.arn
}

output "aws_ecs_task_definition_arn" {
  description = "The ARN of the ECS Cluster"
  value       = aws_ecs_task_definition.main-app.arn
}
output "ecs_service_name" {
  value = var.ecs_service_name
}
output "rds_secret" {
  description = "AWS secret arn for DB access"
  value       = var.rds_secret
}