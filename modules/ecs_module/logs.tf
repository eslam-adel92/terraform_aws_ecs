# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "${var.project_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.cb_log_group.name
}