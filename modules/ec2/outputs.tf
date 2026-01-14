output "id" {
    value = module.ec2-instance.id
}

output "public_ip" {
  value       = module.ec2-instance.public_ip
}
output "private_ip" {
    value  = module.ec2-instance.private_ip
}

output "vpc_id" {
  value = data.aws_vpc.retrieve.id
}
output "vpc_arn" {
  value =  data.aws_vpc.retrieve.arn
}