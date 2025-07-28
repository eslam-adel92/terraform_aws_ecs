provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc_module" {
  source       = "./modules/vpc_module"
  project_name = "app-prod"
  vpc_cidr     = "20.0.0.0/16"
  public_subnet_cidrs = [
    "20.0.0.0/19",
    "20.0.32.0/19",
    "20.0.64.0/19"
  ]
  private_subnet_cidrs = [
    "20.0.96.0/19",
    "20.0.128.0/19",
    "20.0.160.0/19"
  ]
}


# Outputs for the VPC module
output "project_name" {
  value = module.vpc_module.project_name
}

output "vpc_id" {
  value = module.vpc_module.vpc_id
}

output "vpc_cidr" {
  value = module.vpc_module.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc_module.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc_module.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc_module.nat_gateway_id
}

output "nat_gateway_eip" {
  description = "Elastic IP address associated with the NAT Gateway"
  value       = module.vpc_module.nat_gateway_eip
}


module "lb" {
  depends_on = [module.vpc_module]

  source             = "./modules/lb"
  project_name       = module.vpc_module.project_name
  ecs_cluster_name   = module.vpc_module.project_name
  ecs_service_name   = "${module.vpc_module.project_name}-app"
  vpc_id             = module.vpc_module.vpc_id
  public_subnet_ids  = module.vpc_module.public_subnet_ids
  private_subnet_ids = module.vpc_module.private_subnet_ids
  vpc_cidr           = module.vpc_module.vpc_cidr
  health_check_path  = "/"
  # execution_role_arn = "" # TODO: Set the correct execution role ARN here
}

module "ecs_module_app" {
  depends_on = [module.vpc_module]

  load_balancer_arn        = module.lb.lb_arn
  listener_arn             = module.lb.listener_arn
  security_group_id        = module.lb.sg_id
  aws_alb_target_group_arn = module.lb.aws_alb_target_group_arn
  task_role_arn            = module.lb.ecs_task_role_arn
  execution_role_arn       = module.lb.ecs_task_execution_role_arn
  source                   = "./modules/ecs_module"
  region                   = "<region_name>"
  ecs_cluster_name         = module.vpc_module.project_name
  ecs_service_name         = "${module.vpc_module.project_name}-app"
  project_name             = module.vpc_module.project_name
  vpc_id                   = module.vpc_module.vpc_id
  public_subnet_ids        = module.vpc_module.public_subnet_ids
  private_subnet_ids       = module.vpc_module.private_subnet_ids
  vpc_cidr                 = module.vpc_module.vpc_cidr
  cpu                      = 1024
  memory                   = 2048
  containerPort            = 80
  hostPort                 = 80
  desired_count            = 2
  ecs_max_capacity         = 6
  ecs_min_capacity         = 2
  rds_secret               = "<secret_arn>" # TODO: Set the correct RDS secret ARN here
  app_image                = "<app_image_url>" # TODO: Set the correct application image URL here
}

output "ecs_cluster_id" {
  value = module.ecs_module_app.ecs_cluster_id
}

output "ecs_cluster_arn" {
  value = module.ecs_module_app.ecs_cluster_arn
}