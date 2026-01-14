
##    VPC

enable_dns_hostnames_flag = true
enable_dns_support_flag   = true
vpc_name                  = "loginext-vpc"
vpc_cidr_block            = "10.0.0.0/16"

availability_zones = ["ap-south-1a", "ap-south-1b"]

vpc_private_subnets_list = ["10.0.1.0/24"]
vpc_public_subnets_list  = ["10.0.5.0/24","10.0.7.0/24"]
public_subnet_tags = {}
private_subnet_tags = {}


#     security Groups   

security = {
  "loginext-sg" = {
    name                     = "loginext-sg",
    create                   = true,
    create_sg                = true,
    create_timeout           = "1m",
    description              = "security group for loginext",
    attach_to_vpc_name       = "loginext-vpc"
    ingress_cidr_blocks      = [],
    ingress_rules            = [],
    ingress_with_cidr_blocks = [
      {
        rule        = "http-80-tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        rule        = "https-443-tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        rule        = "ssh-tcp"
        cidr_blocks = "0.0.0.0/0"
      }
    ]
    tags = {
      "Role" = "management"
      "Type" = "security_group_pritnul"
    }
    ingress_with_source_security_group_id = [],
    egress_rules                          = ["all-all"]
    egress_with_cidr_blocks               = [],
    egress_with_self                      = [],
    egress_with_source_security_group_id  = []
  },
  "loginext-alb-sg" = {
    name               = "loginext-alb-sg"
    create             = true
    create_sg          = true
    create_timeout     = "1m"
    description        = "ALB security group"
    attach_to_vpc_name = "loginext-vpc"

    ingress_with_cidr_blocks = [
      {
        rule        = "http-80-tcp"
        cidr_blocks = "0.0.0.0/0"
      },
      {
        rule        = "https-443-tcp"
        cidr_blocks = "0.0.0.0/0"
      }
    ]

    ingress_cidr_blocks                   = []
    ingress_rules                         = []
    ingress_with_source_security_group_id = []

    egress_rules            = ["all-all"]
    egress_with_cidr_blocks = []
    egress_with_self        = []
    egress_with_source_security_group_id = []

    tags = {
      Role = "alb"
      Type = "security_group"
    }
  }
}


################################################################################################################
#     EC2 
################################################################################################################

ec2_creation = {

  "loginext-ec2-instance" = {
    create_ec2_flag                      = true
    ec2_key_name                         = "loginext-key"
    ec2_ami                              = "ami-0ced6a024bb18ff2e"
    ec2_subnet_type                      = "private"
    ec2_vpc_name                         = "loginext-vpc"
    ec2_sg_name                          = "loginext-sg"
    ec2_instance_type                    = "t3.micro"
    ec2_attach_iam_role                  = true
    ec2_associate_public_ip_address_flag = true
    ec2_disable_api_termination_flag     = false
    ec2_enable_volume_tags               = true
    ec2_iam_role_name                    = "loginext_infra_role"
    ec2_metadata_options                 = {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
    }
    ec2_root_block_device = []
    ec2_ebs_block_device = []
    ec2_user_data        =  <<-EOF
      #!/bin/bash
      exec > /var/log/user-data.log 2>&1
      set -x
      dnf update -y
      dnf install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello from Loginext Private EC2</h1>" > /var/www/html/index.html
      EOF
  }
}


### loadbalancer

alb_creation = {

  "loginext-alb" = {
    create_alb_flag   = true
    alb_name          = "loginext-alb"
    alb_vpc_name      = "loginext-vpc"
    alb_subnet_type   = "public"
    alb_sg_name       = "loginext-alb-sg"
    alb_internal_flag = false

    alb_listener = {
      port     = 80
      protocol = "HTTP"
    }

    target_group = {
      name             = "loginext-tg"
      port             = 80
      protocol         = "HTTP"
      target_type      = "instance"
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
      }
    }

    alb_targets = [
      "loginext-ec2-instance"
    ]
  }
}
