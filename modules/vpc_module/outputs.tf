# Outputs for the VPC module
output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc_main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.natgw_main.id
}

output "nat_gateway_eip" {
  description = "Elastic IP address associated with the NAT Gateway"
  value       = aws_eip.eip_main.public_ip
}