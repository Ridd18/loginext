

variable "create_vpc_flag" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames_flag" {
  type    = bool
  default = true
}

variable "enable_dns_support_flag" {
  type    = bool
  default = true
}

variable "vpc_to_be_created_name" {
  type    = string
  default = "loginext-vpc"
}

variable "vpc_cidr_block" {
  type    = string
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

variable "public_subnet_tags" {}
variable "private_subnet_tags" {}
