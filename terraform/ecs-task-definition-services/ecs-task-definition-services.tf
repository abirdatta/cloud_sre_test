terraform {
  required_version = ">= 0.12.6"
}

module "chatapp_cw_logs" {
  source = "../resources/CLOUDWATCH_LOG"
  log_group_name = "${terraform.workspace}-${var.log_group_name}"
  log_stream_name = var.log_stream_name
  tags = {
    Name = "${terraform.workspace}-${var.log_group_name}"
    env = terraform.workspace
  }
}

data "aws_caller_identity" "current" {}

module "taskdef_chatapp" {
  source                   = "../resources/TASK-DEFINITION"
  container_definitions    = data.template_file.chatapp_container_def.rendered
  task_definition_name     = "${terraform.workspace}-${var.td_name}"
  network_mode             = "bridge"
}

data "terraform_remote_state" "redis" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/rds-ec-redis"
    region = var.region
  }
}

data "template_file" "chatapp_container_def" {
  template = file("chatapp-container-definition.json")
  vars = {
    log_group_name = module.chatapp_cw_logs.cw_log_group_name
    log_stream_name = module.chatapp_cw_logs.cw_log_stream_name
    account_id = data.aws_caller_identity.current.account_id
    region = var.region
    host_port = var.host_port
    container_port = var.container_port
    memory_reservation = var.memory_reservation
    redis_host = data.terraform_remote_state.redis.outputs.primary_endpoint_address
    chatapp_image_version   = var.chatapp_image_version
    container_name = var.container_name
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/ecs-cluster"
    region = var.region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/alb"
    region = var.region
  }
}

module "chatapp_service" {
  source = "../resources/SERVICES"
  cluster_id = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_id
  task_definition = module.taskdef_chatapp.task_arn
  service_name = "${terraform.workspace}-${var.service_name}"
  desired_count = 2
  target_group_arn = data.terraform_remote_state.alb.outputs.target_group_arn
  container_name = var.container_name
  container_port = var.container_port
}