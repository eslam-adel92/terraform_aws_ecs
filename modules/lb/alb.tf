# alb.tf
# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${var.project_name}-alb-sg"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id
  # depends_on  = [aws_appautoscaling_target.target]
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "main" {
  name            = "${var.project_name}-alb"
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "30"
    path                = var.health_check_path
    unhealthy_threshold = "5"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}