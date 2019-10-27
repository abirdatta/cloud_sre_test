variable "rds_db_sg_name" {
  default = "rds_db_sg"
}

variable "ec_redis_sg_name" {
  default = "ec_redis_sg"
}

variable "alb_sg_name" {
  default = "alb_redis_sg"
}

variable "ec2_sg_name" {
  default = "ec2_sg"
}


variable "remote_state_bucket" {
  default = "chatapp.terraform.tfstate"
}

variable "region" {
  default = "ap-southeast-1"
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