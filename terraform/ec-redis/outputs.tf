output "replication_group_id" {
  value = module.redis.replication_group_id
}

output "primary_endpoint_address" {
  value = module.redis.primary_endpoint_address
}

output "engine" {
  value = module.redis.engine
}

output "engine_version" {
  value = module.redis.engine_version
}

output "member_clusters" {
  value = module.redis.member_clusters
}