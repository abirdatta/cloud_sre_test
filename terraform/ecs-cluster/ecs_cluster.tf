terraform {
  required_version = ">= 0.12.6"
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
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

module "ecs_cluster" {
  source = "../resources/ECS_CLUSTER/"
  ami_id = data.aws_ami.ecs.id
  name = "${terraform.workspace}-${var.name}"
  asg_desired_size = var.asg_desired_size[terraform.workspace]
  asg_max_size = var.asg_max_size[terraform.workspace]
  asg_min_size = var.asg_min_size[terraform.workspace]
  instance_type = var.instance_type[terraform.workspace]
  public_key = var.public_key
  security_groups = [data.terraform_remote_state.security_groups.outputs.ec2_security_group_id]
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_subnets = data.terraform_remote_state.compute-and-db-subnets.outputs.private_compute_subnet_ids
  instance_root_volume_size = var.instance_root_volume_size
  tags = {
    Name        = "${terraform.workspace}-${var.name}"
    env = terraform.workspace
  }
  additional_user_data_script = var.additional_user_data_script
}

