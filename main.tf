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
}

# module "vpc" {
#   source = "./modules/vpc"
#   region = var.region
# }

# module "server" {
#   source          = "./modules/server"
#   region          = var.region
#   node_size       = var.node_size
#   datacenter      = var.datacenter
#   cluster_size    = var.cluster_size
#   ssh_key         = var.ssh_key
#   ssh_private_key = var.ssh_private_key
#   tag             = ["consul-server", "consul-agent", "nomad-server"]
#   vpc_id          = module.vpc.vpc_id
#   ca_cert_path    = module.certificates.ca_cert_path
#   server_cert     = module.certificates.server_cert_path
#   server_key      = module.certificates.server_key_path
# }
