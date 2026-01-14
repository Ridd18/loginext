output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ec2_instance_ids" {
  description = "Map of EC2 instance IDs"
  value = {
    for k, m in module.ec2 :
    k => m.id
  }
}

output "ec2_private_ips" {
  value = {
    for k, m in module.ec2 :
    k => m.private_ip
  }
}
