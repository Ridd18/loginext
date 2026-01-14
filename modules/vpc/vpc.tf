
module "vpc" {
  source               = "../../templates/vpc/terraform-aws-vpc" 
  create_vpc           = var.create_vpc_flag
  enable_dns_hostnames = var.enable_dns_hostnames_flag
  enable_dns_support   = var.enable_dns_support_flag
  name                 = var.vpc_to_be_created_name
  cidr                 = var.vpc_cidr_block
  azs                  = var.availability_zones
  private_subnets      = var.vpc_private_subnets_list
  public_subnets       = var.vpc_public_subnets_list
  tags = {
    "Name"                         = "loginext-vpc"
    "resource-type"                = "vpc"
  }
  private_subnet_tags = merge(var.private_subnet_tags,
    {
      Type = "private"

  })
  public_subnet_tags = merge(var.public_subnet_tags, {
    Type = "public"

  })
}
