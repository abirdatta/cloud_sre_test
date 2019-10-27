variable "vpc_name" {
  description = "the name of the VPC"
  default = "CHATAPP_VPC"
}

variable "cidr_block" {
  description = "CIDR blcok for the VPC"
  default = "29.9.0.0/16"
}