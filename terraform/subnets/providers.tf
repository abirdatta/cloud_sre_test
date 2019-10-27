provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket   = "chatapp.terraform.tfstate"
    key      = "compute-and-db-subnets"
    region   = "ap-southeast-1"
  }
}