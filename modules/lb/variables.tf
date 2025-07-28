variable "project_name" {
  description = "Name of the project (also used for tagging)"
  type        = string
  default     = "eslam-prod"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
  default     = "eslam-prod"
}

variable "health_check_path" {
  default = "/"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "eslam2017/e-capstone:latest"
}

variable "region" {
  description = "The AWS region to deploy the resources"
  default     = "me-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  default     = ""
}

variable "public_subnet_ids" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "cpu" {
  description = "The cpu allocation for the ECS task"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "The memory allocation for the ECS task"
  type        = number
  default     = 1024
}

variable "containerPort" {
  description = "The container Port for the ECS task"
  type        = number
  default     = 80
}

variable "hostPort" {
  description = "The host Port for the ECS task"
  type        = number
  default     = 80
}

variable "command" {
  description = "The command to run in the ECS task"
  type        = list(string)
  default     = null
}

variable "ecs_max_capacity" {
  description = "The maximum number of tasks that can run in the ECS cluster"
  type        = number
  default     = 10
}

variable "ecs_min_capacity" {
  description = "The minimum number of tasks that should always be running in the ECS cluster"
  type        = number
  default     = 2
}

variable "load_balancer_arn" {
  type    = string
  default = ""
}
variable "listener_arn" {
  type    = string
  default = ""
}
variable "security_group_id" {
  type    = string
  default = ""
}
variable "task_role_arn" {
  type    = string
  default = ""
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  type    = string
  default = ""
}