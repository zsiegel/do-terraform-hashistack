terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.20.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

module "droplet" {
  source          = "./modules/droplet"
  region          = var.region
  node_size       = var.node_size
  datacenter      = var.datacenter
  cluster_size    = var.cluster_size
  ssh_key         = var.ssh_key
  ssh_private_key = var.ssh_private_key
  tag             = "nomad"
  vpc_id          = module.vpc.vpc_id
}
