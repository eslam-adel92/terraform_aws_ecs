variable "region" {
  description = "The AWS region to deploy the resources"
  default     = "me-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default = [
    "10.0.0.0/19",
    "10.0.32.0/19",
    "10.0.64.0/19"
  ]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default = [
    "10.0.96.0/19",
    "10.0.128.0/19",
    "10.0.160.0/19"
  ]
}

variable "project_name" {
  description = "The Name tag to apply to all resources"
  type        = string
  default     = "eslam-prod"
}