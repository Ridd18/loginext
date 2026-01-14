output "vpc_all" {
 description = "The name of the vpc."
 value       = module.vpc.*
}
output "vpc_id" {
 description = "The name of the vpc."
 value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
 description = "vpc_cidr_block."
 value       = module.vpc.vpc_cidr_block
}

output "vpc_main_route_table_id" {
 description = "vpc_main_route_table_id"
 value       = module.vpc.vpc_main_route_table_id
}

output "private_subnets" {
 description = "private_subnets"
 value       = module.vpc.private_subnets
}

output "private_subnet_arns" {
 description = "private_subnet_arns"
 value       = module.vpc.private_subnet_arns
}

output "private_route_table_ids" {
 description = "private_route_table_ids."
 value       = module.vpc.private_route_table_ids
}

output "public_subnets" {
 description = "public_subnets"
 value       = module.vpc.public_subnets
}

output "public_subnet_arns" {
 description = "public_subnet_arns"
 value       = module.vpc.public_subnet_arns
}

output "public_route_table_ids" {
 description = "public_route_table_ids"
 value       = module.vpc.public_route_table_ids
}
output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}
output "intra_route_table_ids" {
  value = module.vpc.intra_route_table_ids
}
output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       =  module.vpc.name
}