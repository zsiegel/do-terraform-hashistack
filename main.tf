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

module "certificates" {
  source               = "./modules/certificates"
  common_name          = var.common_name
  organization         = var.organization
  certs_dir            = var.certs_dir
  region               = var.region
  certificate_validity = var.certificate_validity
  datacenter           = var.datacenter
  cluster_size         = var.cluster_size
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
}

module "server" {
  source             = "./modules/server"
  region             = var.region
  node_size          = var.node_size
  datacenter         = var.datacenter
  cluster_size       = var.cluster_size
  ssh_key            = var.ssh_key
  ssh_private_key    = var.ssh_private_key
  tags               = ["consul-server", "consul-agent", "nomad-server"]
  vpc_id             = module.vpc.vpc_id
  ca_cert_path       = module.certificates.ca_cert_path
  nomad_server_cert  = module.certificates.nomad_server_cert_path
  nomad_server_key   = module.certificates.nomad_server_key_path
  consul_server_cert = module.certificates.consul_server_cert_path
  consul_server_key  = module.certificates.consul_server_key_path
}
