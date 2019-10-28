provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket   = "chatapp.terraform.tfstate"
    key      = "alb"
    region   = "ap-southeast-1"
  }
}