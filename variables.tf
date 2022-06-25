variable "do_token" {}
variable "ssh_key" {}
variable "ssh_private_key" {}

variable "cluster_size" {
  description = "The number of nodes in the cluster. Should be odd number for hashistack"
  type        = number
  default     = 3
}

variable "datacenter" {
  description = "The name of the datacenter"
  type        = string
  default     = "dc1"
}

// Run `doctl compute region list` to get a list of available regions
variable "region" {
  description = "The digital ocean region slug for where to create resources"
  type        = string
  default     = "nyc1"
}

// Run `doctl compute size list` to get a list of available nodes
variable "node_size" {
  description = "The default digital ocean node slug for each node in the default pool"
  type        = string
  default     = "s-4vcpu-8gb-amd"
}
