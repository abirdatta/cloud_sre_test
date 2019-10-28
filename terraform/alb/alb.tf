terraform {
  required_version = ">= 0.12.6"
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/security_groups"
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/vpc"
    region = var.region
  }
}

data "terraform_remote_state" "compute-and-db-subnets" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/compute-and-db-subnets"
    region = var.region
  }
}

module "alb_and_target_group" {
  source = "../resources/ALB/"
  env = terraform.workspace
  load_balancer_name = "${terraform.workspace}-${var.load_balancer_name}"
  log_bucket_name = "${terraform.workspace}-${var.load_balancer_name}"
  port = var.port
  protocol = var.protocol
  security_groups = [data.terraform_remote_state.security_groups.outputs.alb_security_group_id]
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = data.terraform_remote_state.compute-and-db-subnets.outputs.public_compute_subnet_ids
  target_group_name = "${terraform.workspace}-${var.target_group_name}"
  health_check_healthy_threshold = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_interval = var.health_check_interval
  health_check_path = var.health_check_path
  health_check_port = var.health_check_port
  health_check_protocol = var.health_check_protocol
  health_check_timeout = var.health_check_timeout
  health_check_matcher = var.health_check_matcher
  logging_enabled = var.logging_enabled
  tags = {
    Name = "${terraform.workspace}-${var.load_balancer_name}"
    env  = terraform.workspace
  }
}