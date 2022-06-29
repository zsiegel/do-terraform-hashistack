terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.3"
    }
  }
}

variable "common_name" {}
variable "organization" {}
variable "certs_dir" {}
variable "region" {}

