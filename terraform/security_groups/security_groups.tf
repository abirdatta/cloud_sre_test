terraform {
  required_version = ">= 0.12.6"
}

module "rds_db_security_group" {
  source = "../resources/SECURITY_GROUP/"
  env = terraform.workspace
  sg_name = "${terraform.workspace}-${var.rds_db_sg_name}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_desc = "Security Group for RDS instances"
  ingress_rules_list = [
    {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = data.terraform_remote_state.compute-and-db-subnets.outputs.private_compute_subnet_cidrs
      security_groups = []
    }
  ]
  egress_rules_list = []
}

module "elasticache_redis_security_group" {
  source = "../resources/SECURITY_GROUP/"
  env = terraform.workspace
  sg_name = "${terraform.workspace}-${var.ec_redis_sg_name}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_desc = "Security Group for Elasticache redis instances"
  ingress_rules_list = [
    {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      cidr_blocks = data.terraform_remote_state.compute-and-db-subnets.outputs.private_compute_subnet_cidrs
      security_groups = []
    }
  ]
  egress_rules_list = []
}

module "alb_security_group" {
  source = "../resources/SECURITY_GROUP/"
  env = terraform.workspace
  sg_name = "${terraform.workspace}-${var.alb_sg_name}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_desc = "Security Group for Application Load Balancer"
  ingress_rules_list = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
  egress_rules_list = [
    {
      from_port = 32768
      to_port = 61000
      protocol = "tcp"
      cidr_blocks = data.terraform_remote_state.compute-and-db-subnets.outputs.private_compute_subnet_cidrs
      security_groups = []
    }
  ]
}

module "ec2_security_group" {
  source = "../resources/SECURITY_GROUP/"
  env = terraform.workspace
  sg_name = "${terraform.workspace}-${var.ec2_sg_name}"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_desc = "Security Group for EC2s in ECS cluster"
  ingress_rules_list = [
    {
      from_port = 32768
      to_port = 61000
      protocol = "tcp"
      cidr_blocks = []
      security_groups = [module.alb_security_group.security_group_id]
    }
  ]
  egress_rules_list = [
    {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      cidr_blocks = []
      security_groups = [module.elasticache_redis_security_group.security_group_id]
    },
    {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = []
      security_groups = [module.rds_db_security_group.security_group_id]
    }
  ]
}

