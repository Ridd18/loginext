variable "ec2_key_name" {}
variable "ec2_instance_name" {}
variable "create_ec2_flag" {}
variable "ec2_ami" {}
variable "ec2_vpc_name" {}
variable "ec2_sg_name" {}
variable "ec2_subnet_type" {}
variable "ec2_instance_type" {}
variable "ec2_associate_public_ip_address_flag" {} 
variable "ec2_disable_api_termination_flag" {}    
variable "ec2_enable_volume_tags" {}
variable "ec2_iam_role_name" {}
variable "user_data" {default = null}
variable "attach_iam_role" {}
variable "ec2_root_block_device" {
   type = list(any)
}
variable "ebs_block_device" {
    type = list(any)
}
variable "ec2_metadata_options" {}

