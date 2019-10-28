output "rds_db_security_group_id" {
  value = module.rds_db_security_group.security_group_id
}

output "alb_security_group_id" {
  value = module.alb_security_group.security_group_id
}

output "ecredis_security_group_id" {
  value = module.elasticache_redis_security_group.security_group_id
}

output "ec2_security_group_id" {
  value = module.ec2_security_group.security_group_id
}