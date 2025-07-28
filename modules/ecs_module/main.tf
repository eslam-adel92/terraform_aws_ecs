resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = var.project_name
  }
}