data "aws_vpc" "retrieve" {
  filter {
    name   = "tag:Name"
    values = ["${var.ec2_vpc_name}"]
  }
}

data "aws_subnets" "ec2_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.retrieve.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

resource "random_integer" "priority" {
  count = length(data.aws_subnets.ec2_subnet.ids) > 0 ? 1 : 0

  min = 0
  max = length(data.aws_subnets.ec2_subnet.ids) - 1

  keepers = {
    listener = data.aws_vpc.retrieve.id
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  count = var.attach_iam_role ? 1 : 0
  name = var.ec2_instance_name
  role = "${var.ec2_iam_role_name}"
}

module "ec2-instance" {
  source                      = "../../templates/ec2/terraform-aws-ec2-instance" 
  key_name                    = var.ec2_key_name
  create                      = var.create_ec2_flag
  name                        = var.ec2_instance_name
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = data.aws_subnets.ec2_subnet.ids[random_integer.priority[0].result] 
  vpc_security_group_ids      = [var.ec2_sg_name]
  associate_public_ip_address = false
  disable_api_termination     = var.ec2_disable_api_termination_flag 
  enable_volume_tags          = false
  user_data                   = var.user_data
  ebs_block_device            = var.ebs_block_device
  root_block_device = var.ec2_root_block_device
  metadata_options  = var.ec2_metadata_options

  tags = {
    "VPC"  = "${data.aws_vpc.retrieve.id}"
    "Type" = "${var.ec2_instance_type}"
  }
}

