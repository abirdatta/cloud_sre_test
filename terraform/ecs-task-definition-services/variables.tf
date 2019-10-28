variable "log_group_name" {
  default = "chatapp-demo"
}

variable "log_stream_name" {
  default = "task-logs"
}

variable "remote_state_bucket" {
  default = "chatapp.terraform.tfstate"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "host_port" {
  default = 0
}

variable "container_port" {
  default = 8080
}

variable "memory_reservation" {
  default = 500
}

variable "chatapp_image_version" {
  default = "latest"
}

variable "td_name" {
  default = "chatapp-task-def"
}

variable "service_name" {
  default = "chatapp-service"
}

variable "container_name" {
  default = "chatapp_container"
}