variable "remote_state_bucket" {
  default = "chatapp.terraform.tfstate"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "zones_cidr_map_compute_private" {
  description = "Zones and CIDR map"
  type = map(map(string))
  default = {
    dev = {
      "a" = "28.9.1.0/24"
      "b" = "28.9.2.0/24"
      "c" = "28.9.3.0/24"
    },
    qa = {
      "a" = "29.9.1.0/24"
      "b" = "29.9.2.0/24"
      "c" = "29.9.3.0/24"
    },
    prod = {
      "a" = "30.9.1.0/24"
      "b" = "30.9.2.0/24"
      "c" = "30.9.3.0/24"
    },
    default = {
      "a" = "10.1.1.0/24"
      "b" = "10.1.2.0/24"
      "c" = "10.1.3.0/24"
    }
  }
}

variable "subnet_name_prefix_compute_private" {
  description = "subnet name prefix like compute-private, db-private etc."
  default = "compute-private"
}

variable "subnet_name_prefix_db_private" {
  description = "subnet name prefix like compute-private, db-private etc."
  default = "db-private"
}

variable "zones_cidr_map_db_private" {
  description = "Zones and CIDR map"
  type = map(map(string))
  default = {
    dev = {
      "a" = "28.9.4.0/24"
      "b" = "28.9.5.0/24"
      "c" = "28.9.6.0/24"
    },
    qa = {
      "a" = "29.9.4.0/24"
      "b" = "29.9.5.0/24"
      "c" = "29.9.6.0/24"
    },
    prod = {
      "a" = "30.9.4.0/24"
      "b" = "30.9.5.0/24"
      "c" = "30.9.6.0/24"
    },
    default = {
      "a" = "10.1.4.0/24"
      "b" = "10.1.5.0/24"
      "c" = "10.1.6.0/24"
    }
  }
}

variable "zones_cidr_map_compute_public" {
  description = "Zones and CIDR map"
  type = map(map(string))
  default = {
    dev = {
      "a" = "28.9.7.0/24"
      "b" = "28.9.8.0/24"
      "c" = "28.9.9.0/24"
    },
    qa = {
      "a" = "29.9.7.0/24"
      "b" = "29.9.8.0/24"
      "c" = "29.9.9.0/24"
    },
    prod = {
      "a" = "30.9.7.0/24"
      "b" = "30.9.8.0/24"
      "c" = "30.9.9.0/24"
    },
    default = {
      "a" = "10.1.7.0/24"
      "b" = "10.1.8.0/24"
      "c" = "10.1.9.0/24"
    }
  }
}

variable "subnet_name_prefix_compute_public" {
  description = "subnet name prefix like compute-private, db-private etc."
  default = "compute-public"
}

variable "internet_gateway_cidr" {
  default = "0.0.0.0/0"
}

variable "public_subnet_route_table_name" {
  default = "public_route_table"
}
