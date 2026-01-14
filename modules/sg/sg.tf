
data "aws_security_group" "retrieve" {
  for_each = {for name in var.ingress_with_source_security_group_id:  name.source_security_group_id => name
  if var.ingress_with_source_security_group_id !=[]
  }
  filter {
    name = "tag:Name"
   values = [each.value.source_security_group_id] 
  }
}
locals {
  objectmap = var.ingress_with_source_security_group_id != []?{ for key , value in data.aws_security_group.retrieve: value.name =>{for id , id_val in data.aws_security_group.retrieve[*]: "source_security_group_id"=>value.id}} : {}
  common_variables_map = local.objectmap != {}?{ for v in var.ingress_with_source_security_group_id : "${v.source_security_group_id}" => v } : {}
  merged_value = local.objectmap != {}?{ for key,value in local.common_variables_map: key=>merge(value , local.objectmap["${key}"] )} :{}
}

module "vote_service_sg" {
  depends_on = [
    data.aws_security_group.retrieve
  ]
  source = "../../templates/sg/terraform-aws-security-group"
  vpc_id                                  = var.attach_to_vpc_name 
  name                                    = var.name
  create                                  = var.create
  create_sg                               = var.create_sg
  create_timeout                          = var.create_timeout
  description                             = var.description
  ingress_cidr_blocks                     = var.ingress_cidr_blocks
  ingress_rules                           = var.ingress_rules
  ingress_with_cidr_blocks                = var.ingress_with_cidr_blocks
  ingress_with_source_security_group_id   = var.ingress_with_source_security_group_id !=[]? values(local.merged_value) : []
  egress_rules                            = var.egress_rules
  egress_with_cidr_blocks                 = var.egress_with_cidr_blocks
  egress_with_self                        = var.egress_with_self
  egress_with_source_security_group_id    = var.egress_with_source_security_group_id
  tags = var.tags
}
