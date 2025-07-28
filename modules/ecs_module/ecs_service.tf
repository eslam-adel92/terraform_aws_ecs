# ECS Service Security Group
resource "aws_security_group" "ecs_service" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allow all traffic from VPC CIDR for ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

# ECS Service
resource "aws_ecs_service" "app-service" {
  depends_on = [
    # aws_iam_role.ecs_task_role,
    # aws_iam_role_policy.ecs_task_policy,
    aws_ecs_cluster.ecs-cluster,
    aws_ecs_task_definition.main-app,
    aws_security_group.ecs_service
    # aws_alb_listener.front_end
  ]
  name                          = var.ecs_service_name
  cluster                       = aws_ecs_cluster.ecs-cluster.id
  task_definition               = aws_ecs_task_definition.main-app.arn
  desired_count                 = var.desired_count
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  enable_ecs_managed_tags = true
  propagate_tags          = "TASK_DEFINITION"

  enable_execute_command = true

  dynamic "load_balancer" {
    for_each = (var.aws_alb_target_group_arn != null && var.aws_alb_target_group_arn != "") ? [1] : []
    content {
      target_group_arn = var.aws_alb_target_group_arn
      container_name   = var.project_name
      container_port   = var.containerPort
    }
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Name = var.project_name
  }
}

# ECS Service Auto Scaling
resource "aws_appautoscaling_target" "ecs" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.app-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  lifecycle {
    ignore_changes = [
      max_capacity,
      min_capacity
    ]
  }
  depends_on = [aws_ecs_service.app-service]
}

resource "aws_appautoscaling_policy" "cpu" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "CPU"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 30
    scale_out_cooldown = 300
  }
}