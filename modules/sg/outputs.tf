output "security_group_arn" {
 description = "public_route_table_ids"
 value       = module.vote_service_sg.security_group_arn
}

output "security_group_id" {
 description = "security_group_id"
 value       = module.vote_service_sg.security_group_id
}

output "security_group_name" {
 description = "security_group_name"
 value       = module.vote_service_sg.security_group_name
}

output "security_group_owner_id" {
 description = "security_group_owner_id"
 value       = module.vote_service_sg.security_group_owner_id
}

output "security_group_vpc_id" {
 description = "security_group_vpc_id"
 value       = module.vote_service_sg.security_group_vpc_id
}
