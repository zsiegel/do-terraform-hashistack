terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.20.0"
    }
  }
}

variable "ssh_key" {}
variable "ssh_private_key" {}
variable "cluster_size" {}
variable "datacenter" {}
variable "region" {}
variable "node_size" {}
variable "tag" {}
variable "vpc_id" {}

resource "digitalocean_ssh_key" "default" {
  name       = "nomad-ssh-key"
  public_key = file(var.ssh_key)
}


resource "digitalocean_droplet" "server" {
  count     = var.cluster_size
  name      = "nomad-cluster-${count.index + 1}"
  image     = "debian-11-x64"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.default.fingerprint]
  tags      = [var.tag]
  vpc_uuid  = var.vpc_id
  user_data = file("${path.module}/config/cloud-init")

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    agent       = true
    timeout     = "1m"
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    content = templatefile("${path.module}/config/nomad.tftpl", {
      # Nomad is only listening on the private network
      # In order to connect to Nomad from outside the private network 
      # you must use SSH port forwarding.
      # 
      # Example: ssh -N -L 4646:{PRIVATE_IP}:4646 root@{PUBLIC_IP}
      bind_addr    = self.ipv4_address_private
      join_addr    = digitalocean_droplet.server.0.ipv4_address_private
      datacenter   = var.datacenter
      cluster_size = var.cluster_size
    })
    destination = "/opt/nomad.d/nomad.hcl"
  }

  provisioner "file" {
    content     = file("${path.module}/config/nomad.service")
    destination = "/etc/systemd/system/nomad.service"
  }

  # Wait for cloud-init to finish (see user_data above) 
  # Start nomad service
  # TODO move this all to cloud-init?
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "systemctl enable nomad.service",
      "systemctl start nomad.service",
    ]
  }

  depends_on = [
    digitalocean_ssh_key.default
  ]
}

output "servers" {
  value = digitalocean_droplet.server.*.id
}

output "ip" {
  value = digitalocean_droplet.server.*.ipv4_address
}
