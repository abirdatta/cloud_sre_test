terraform {
  required_version = ">= 0.12.6"
}

data "terraform_remote_state" "compute-and-db-subnets" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/compute-and-db-subnets"
    region = var.region
  }
}

module "ec_subnet_group" {
  source = "../resources/ELASTICACHE_SUBNET_GROUP"
  subnet_ids = data.terraform_remote_state.compute-and-db-subnets.outputs.private_db_subnet_ids
  subnet_group_name = "${terraform.workspace}-ec-subnet-group"
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/security_groups"
    region = var.region
  }
}

module "redis" {
  source = "../resources/ELASTICACHE/"
  automatic_failover_enabled = var.automatic_failover_enabled
  az = var.az
  engine_version = var.engine_version
  node_type = var.node_type[terraform.workspace]
  number_cache_clusters = var.number_cache_clusters
  parameter_group_name = var.parameter_group_name
  port = var.port
  replication_group_description = var.replication_group_description
  replication_group_id = var.replication_group_id
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.ecredis_security_group_id]
  subnet_group_name = module.ec_subnet_group.ec_subnet_group_name
  tags = {
    Name = "${terraform.workspace}-redis"
    env = terraform.workspace
  }
  engine = var.engine
  maintenance_window = var.maintenance_window
}
