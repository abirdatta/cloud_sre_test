variable "instance_type" {
  description = "EC2 instance type"
  type = map(string)
  default = {
    dev = "t2.small"
    qa = "t2.medium"
    prod = "m5.large"
    default = "t2.micro"
  }
}

variable "name" {
  description = "Base name to use for resources in the module"
  default = "chatapp-ecs"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9RgWhGGzWZvX+mVXGofe6Pv2Jybazb2L6KrS/e4vadFdzYkhFSrtREjr/gEWAPokMzXDX+dxg+XPS9V66vAkEAxqZrgBzfDpXUEOipDO9mL9IGlJH3G8s90REXmDO2ZSik9UMUi9eHzbQdUeHhc7KaFBhFFA4m5DSR1rqL6IQ3gyAC+567Aoyj60plTX26D3VzS5h0/LUTV8be7xoNjP7vu3bgD7R02eYgQotBrSL0+J2xalpX1G1SEnVmZBg8IPy11iuxg5I5BCrpdU+3ajsf/4/l9VAxZ8YnltkfbG5DBOvABNSwCH3JIc2p3jv6fmKmajbBno7Dy5737/Z0Rh/ abirdatta.in@gmail.com"
}

variable "asg_desired_size" {
  type = map(string)
  default = {
    dev = 1
    qa = 1
    prod = 2
    default = 1
  }
}

variable "asg_max_size" {
  type = map(string)
  default = {
    dev = 2
    qa = 2
    prod = 4
    default = 1
  }
}

variable "asg_min_size" {
  type = map(string)
  default = {
    dev = 1
    qa = 1
    prod = 1
    default = 1
  }
}

variable "remote_state_bucket" {
  default = "chatapp.terraform.tfstate"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "instance_root_volume_size" {
  default = 60
}

variable "additional_user_data_script" {
  default = "sudo yum install -y mysql"
}