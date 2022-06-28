terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.20.0"
    }
  }
}

variable "region" {}

resource "digitalocean_vpc" "vpc" {
  name   = "hashistack-vpc"
  region = var.region
}

output "vpc_id" {
  value = digitalocean_vpc.vpc.id
}
