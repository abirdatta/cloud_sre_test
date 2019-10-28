data "terraform_remote_state" "compute-and-db-subnets" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/compute-and-db-subnets"
    region = var.region
  }
}

module "db_subnet_group" {
  source = "../resources/DB_SUBNET_GROUP"
  env = terraform.workspace
  subnet_ids = data.terraform_remote_state.compute-and-db-subnets.outputs.private_db_subnet_ids
  subnet_group_name = "${terraform.workspace}-db_subnet_group"
  tag_name = "${terraform.workspace}-db_subnet_group"
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "env:/${terraform.workspace}/security_groups"
    region = var.region
  }
}

module "maria" {
  source = "../resources/RDS/"
  allocated_storage = var.allocated_storage[terraform.workspace]
  engine = var.engine
  engine_version = var.engine_version
  identifier = "${terraform.workspace}-${var.identifier}"
  backup_window = var.backup_window
  instance_class = var.instance_class[terraform.workspace]
  maintenance_window = var.maintenance_window
  password = var.password
  port = var.port
  username = var.username
  name = "${var.name}${terraform.workspace}"
  db_subnet_group_name = module.db_subnet_group.db_subnet_group_name
  vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.rds_db_security_group_id]
  multi_az = var.multi_az[terraform.workspace]
  tags = {
    Name = "${terraform.workspace}-mariadb"
    env = terraform.workspace
  }
}
