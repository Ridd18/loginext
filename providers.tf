terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "loginext-tfstate-store"
    key            = "ec2-alb-automation/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::525375332911:role/loginext_infra_role"
  }
}
