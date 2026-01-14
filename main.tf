#######################################################################################################################
#                                             VPC                                                                     #
#######################################################################################################################
module "vpc" {
  source                    = "./modules/vpc"
  create_vpc_flag           = true
  enable_dns_hostnames_flag = var.enable_dns_hostnames_flag
  enable_dns_support_flag   = var.enable_dns_support_flag
  vpc_to_be_created_name    = var.vpc_name
  vpc_cidr_block            = var.vpc_cidr_block
  availability_zones        = var.availability_zones
  vpc_private_subnets_list  = var.vpc_private_subnets_list
  vpc_public_subnets_list   = var.vpc_public_subnets_list
  public_subnet_tags        = var.public_subnet_tags
  private_subnet_tags       = var.private_subnet_tags
}


#######################################################################################################################
#                                             Security Groups                                                         #
#######################################################################################################################
module "vote_service_sg" {
  for_each = var.security
  source   = "./modules/sg"

  attach_to_vpc_name                    = module.vpc.vpc_id
  name                                  = each.key
  create                                = each.value.create
  create_sg                             = each.value.create_sg
  create_timeout                        = each.value.create_timeout
  description                           = each.value.description
  ingress_cidr_blocks                   = each.value.ingress_cidr_blocks
  ingress_rules                         = each.value.ingress_rules
  ingress_with_cidr_blocks              = each.value.ingress_with_cidr_blocks
  ingress_with_source_security_group_id = each.value.ingress_with_source_security_group_id
  egress_rules                          = each.value.egress_rules
  egress_with_cidr_blocks               = each.value.egress_with_cidr_blocks
  egress_with_self                      = each.value.egress_with_self
  egress_with_source_security_group_id  = each.value.egress_with_source_security_group_id
  tags                                  = each.value.tags
}

######################################################################################################
#                                               EC2                                                  #
######################################################################################################

module "ec2" {
  for_each = {
    for keyx, valuex in var.ec2_creation : keyx => valuex
    if valuex.create_ec2_flag
  }
  create_ec2_flag = each.value.create_ec2_flag
  source                               = "./modules/ec2"
  ec2_key_name                         = each.value.ec2_key_name
  ec2_instance_name                    = each.key
  ec2_ami                              = each.value.ec2_ami
  ec2_vpc_name                         = module.vpc.name
  ec2_subnet_type                      = each.value.ec2_subnet_type
  ec2_sg_name                          = module.vote_service_sg["${each.value.ec2_sg_name}"].security_group_id 
  ec2_instance_type                    = each.value.ec2_instance_type
  ec2_associate_public_ip_address_flag = each.value.ec2_associate_public_ip_address_flag
  ec2_disable_api_termination_flag     = each.value.ec2_disable_api_termination_flag
  ec2_enable_volume_tags               = each.value.ec2_enable_volume_tags
  ec2_root_block_device                = each.value.ec2_root_block_device
  user_data                            = each.value.ec2_user_data
  attach_iam_role                      = each.value.ec2_attach_iam_role
  ebs_block_device                     = each.value.ec2_ebs_block_device
  ec2_iam_role_name                    = each.value.ec2_iam_role_name
  ec2_metadata_options                 = each.value.ec2_metadata_options
}


######################################################################################################
#                                               Loadbalancer                                         #
######################################################################################################

module "alb" {
  source = "./modules/alb"
  alb_creation      = var.alb_creation
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  ec2_instance_ids  = {
    for k, m in module.ec2 :
    k => m.id
  }

}

