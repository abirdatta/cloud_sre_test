output "rds_db_security_group_id" {
  value = module.rds_db_security_group.security_group_id
}

output "rds_alb_security_group_id" {
  value = module.alb_security_group.security_group_id
}

output "rds_ecredis_security_group_id" {
  value = module.elasticache_redis_security_group.security_group_id
}

output "rds_ec2_security_group_id" {
  value = module.ec2_security_group.security_group_id
}