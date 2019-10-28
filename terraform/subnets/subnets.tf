terraform {
  required_version = ">= 0.12.6"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/vpc"
    region = var.region
  }
}

module "compute_private_subnets" {
  source = "../resources/SUBNETS/"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  region = var.region
  subnet_name_prefix = var.subnet_name_prefix_compute_private
  zones_cidr_map = var.zones_cidr_map_compute_private[terraform.workspace]
  env = terraform.workspace
}

module "db_private_subnets" {
  source = "../resources/SUBNETS/"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  region = var.region
  subnet_name_prefix = var.subnet_name_prefix_db_private
  zones_cidr_map = var.zones_cidr_map_db_private[terraform.workspace]
  env = terraform.workspace
}

module "compute_public_subnets" {
  source = "../resources/SUBNETS/"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  region = var.region
  subnet_name_prefix = var.subnet_name_prefix_compute_public
  zones_cidr_map = var.zones_cidr_map_compute_public[terraform.workspace]
  env = terraform.workspace
  map_public_ip_on_launch = true
}

module "nat_gateway" {
  source = "../resources/NAT_GATEWAY/"
  subnet_id = element(module.compute_public_subnets.subnet_ids, 0)
  env = terraform.workspace
  name = "${terraform.workspace}-nat-gateway"
}

module "private_subnet_route_table" {
  source = "../resources/ROUTE_TABLE/"
  cidr_gateway_id_map = {
    "0.0.0.0/0" = module.nat_gateway.nat_gateway_id
  }
  env = terraform.workspace
  route_table_name = var.private_subnet_route_table_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

module "compute_private_subnet_ngw_association"{
  source = "../resources/ROUTE_TABLE_ASSOCIATION"
  route_table_id = module.private_subnet_route_table.route_table_id
  subnet_id_map = module.compute_private_subnets.az_subnet_id_map
}

module "internet_gateway" {
  source = "../resources/INTERNET_GATEWAY/"
  env = terraform.workspace
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

module "public_subnet_route_table" {
  source = "../resources/ROUTE_TABLE/"
  cidr_gateway_id_map = {
    "0.0.0.0/0" = module.internet_gateway.internet_gateway_id
  }
  env = terraform.workspace
  route_table_name = var.public_subnet_route_table_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

module "compute_public_subnet_igw_association"{
  source = "../resources/ROUTE_TABLE_ASSOCIATION"
  route_table_id = module.public_subnet_route_table.route_table_id
  subnet_id_map = module.compute_public_subnets.az_subnet_id_map
}