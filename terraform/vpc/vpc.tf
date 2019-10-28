terraform {
  required_version = ">= 0.12, < 0.13"
}

module "chatapp_vpc" {
  source = "../resources/VPC/"
  cidr_block = var.vpc_cidr[terraform.workspace]
  tags = {
    Name = "${terraform.workspace}-${var.vpc_name}"
    env = terraform.workspace
  }
}