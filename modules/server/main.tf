terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.20.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.3"
    }
  }
}

variable "ca_cert_path" {}
variable "nomad_server_cert" {}
variable "nomad_server_key" {}
variable "consul_server_cert" { default = [] }
variable "consul_server_key" { default = [] }
variable "ssh_key" {}
variable "ssh_private_key" {}
variable "cluster_size" {}
variable "datacenter" {}
variable "region" {}
variable "node_size" {}
variable "tags" {}
variable "vpc_id" {}
