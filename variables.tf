variable "aws_region" {
  default = "ap-south-1"
}


######################################################################################################
#                                               VPC                                                  #
######################################################################################################

variable "enable_dns_hostnames_flag" {
  type = bool
}

variable "enable_dns_support_flag" {
  type = bool
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_private_subnets_list" {
  type = list(string)
}

variable "vpc_public_subnets_list" {
  type = list(string)
}

variable "terraform_tag_flag" {
  type    = bool
  default = true
}
variable "environment_tag" {
  type    = string
  default = "test"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  default     = "my-keypair"
}

variable "public_subnet_tags" { type = map(string) }
variable "private_subnet_tags" { type = map(string) }


######################################################################################################
#                                               SG                                                   #
######################################################################################################

variable "security" {
  type = map(object({
    name                                  = string
    create                                = bool
    create_sg                             = bool
    create_timeout                        = string
    attach_to_vpc_name                    = string
    description                           = string
    ingress_cidr_blocks                   = list(string)
    ingress_rules                         = list(string)
    ingress_with_cidr_blocks              = list(map(string))
    ingress_with_source_security_group_id = list(map(string))
    egress_rules                          = list(string)
    egress_with_cidr_blocks               = list(map(string))
    egress_with_self                      = list(map(string))
    egress_with_source_security_group_id  = list(map(string))
    tags                                  = map(string)
  }))
}

######################################################################################################
#                                               EC2                                                  #
######################################################################################################

variable "ec2_creation" {
  description = "Create EC2 on AWS."
  type = map(object({
    ec2_key_name                         = string
    create_ec2_flag                      = bool
    ec2_ami                              = string
    ec2_vpc_name                         = string
    ec2_subnet_type                      = string
    ec2_sg_name                          = string
    ec2_instance_type                    = string
    ec2_associate_public_ip_address_flag = bool
    ec2_disable_api_termination_flag     = bool
    ec2_enable_volume_tags               = bool
    ec2_user_data                        = string
    ec2_attach_iam_role                  = bool
    ec2_ebs_block_device                 = list(any)
    ec2_root_block_device                = list(any)
    ec2_iam_role_name                    = string
    ec2_metadata_options                 = map(string)
  }))
}

######################################################################################################
#                                               Loadbalancer                                         #
######################################################################################################

variable "alb_creation" {
  type = map(object({
    create_alb_flag   = bool
    alb_name          = string
    alb_vpc_name      = string
    alb_subnet_type   = string
    alb_sg_name       = string
    alb_internal_flag = bool

    alb_listener = object({
      port     = number
      protocol = string
    })

    target_group = object({
      name        = string
      port        = number
      protocol    = string
      target_type = string

      health_check = object({
        path                = string
        interval            = number
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
        matcher             = string
      })
    })

    alb_targets = list(string)
  }))
}
