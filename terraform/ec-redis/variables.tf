variable "remote_state_bucket" {
  default = "chatapp.terraform.tfstate"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "engine" {
  description = "Engine of Elasticache cluster, memcached or redis"
  default = "redis"
}

variable "node_type" {
  description = "Node Instance type"
  type = map(string)
  default = {
    dev = "cache.t2.small"
    qa = "cache.m5.large"
    prod = "cache.m5.xlarge"
  }
}

variable "parameter_group_name" {
  description = "Parameter group name"
  default = "default.redis3.2"
}
variable "engine_version" {
  description = "Engine version of elasticache engine"
  default = "3.2.6"
}
variable "port" {
  description = "port value of engine"
  default = 6379
}
variable "maintenance_window" {
  default = "sun:00:00-sun:03:00"
}

variable "az" {
  type = list(string)
  description = "Availabililty Zones"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "replication_group_id" {
  description = "Resplication Group Id"
  default = "chatapp-rep-redis"
}

variable "replication_group_description" {
  description = "Resplication Group Desc"
  default = "Chatapp Redis replication group"
}

variable "number_cache_clusters" {
  description = "(Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. "
  default = 2
}

variable "automatic_failover_enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false"
  type = bool
  default = true
}