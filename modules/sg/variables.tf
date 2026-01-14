variable "attach_to_vpc_name" {type = string}
variable "name" {}
variable "create" {}
variable "create_sg" {}
variable "create_timeout" {}
variable "description" {}                          
variable "ingress_cidr_blocks" {}                 
variable "ingress_rules" {}                            
variable "ingress_with_cidr_blocks" {}                 
variable "ingress_with_source_security_group_id" {}    
variable "egress_rules" {}                             
variable "egress_with_cidr_blocks" {}                 
variable "egress_with_self" {}                         
variable "egress_with_source_security_group_id" {}
variable "tags" {}    


