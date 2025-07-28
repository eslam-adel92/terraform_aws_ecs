variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "app"
}

variable "app_image" {
  description = "Docker image for the app"
  type        = string
}

variable "rds_secret" {
  description = "ARN of the RDS secret"
  type        = string
  default     = ""
}