variable "vpc_name" {
  description = "the name of the VPC"
  default = "CHATAPP_VPC"
}

variable "cidr_block" {
  description = "CIDR blcok for the VPC"
  default = "29.9.0.0/16"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = map(string)
  default     = {
    dev       = "28.9.0.0/16"
    qa        = "29.9.0.0/16"
    prod      = "30.9.0.0/16"
    default   = "10.1.0.0/16"
  }
}