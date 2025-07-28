resource "aws_ecs_task_definition" "main-app" {
  # depends_on = [
  #   aws_iam_role.ecs_task_role,
  #   aws_iam_role_policy.ecs_task_policy
  # ]

  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn

  ephemeral_storage {
    size_in_gib = 30
  }

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}"
      image     = "${var.app_image}"
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      command   = var.command
      portMappings = [
        {
          containerPort = var.containerPort
          hostPort      = var.hostPort
          protocol      = "tcp"
          name          = "web_port"
          appProtocol   = "http"
        }
      ]
      restartPolicy = {
        enabled              = true
        ignoredExitCodes     = [0]
        restartAttemptPeriod = 300
      }
      secrets = [
        {
          "name" : "DB_USERNAME",
          "valueFrom" : "${var.rds_secret}:username::"
        },
        {
          "name" : "DB_PASSWORD",
          "valueFrom" : "${var.rds_secret}:password::"
        },
        {
          "name" : "DB_HOST",
          "valueFrom" : "${var.rds_secret}:host::"
        },
        {
          "name" : "DB_PORT",
          "valueFrom" : "${var.rds_secret}:port::"
        },
        {
          "name" : "DB_DATABASE",
          "valueFrom" : "${var.rds_secret}:username::"
        }
      ]
      environment      = []
      environmentFiles = []
      # mountPoints = [
      #   {
      #     sourceVolume  = "shared-www"
      #     containerPath = "/var/www/html/"
      #     readOnly      = false
      #   }
      # ]
      volumesFrom = []
      dockerLabels = {
        Name = "${var.project_name}"
      }
      ulimits = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}"
          mode                  = "non-blocking"
          awslogs-create-group  = "true"
          max-buffer-size       = "25m"
          awslogs-region        = "${var.region}"
          awslogs-stream-prefix = "${var.project_name}-log-stream"
        }
        secretOptions = []
      }
      systemControls = []
    }
  ])

  # volume {
  #   name = "shared-www"
  #   host_path = null
  # }

  tags = {
    Name = var.project_name
  }
}