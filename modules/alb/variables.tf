variable "alb_creation" {
  type = map(any)
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ec2_instance_ids" {
  type = map(string)
}
