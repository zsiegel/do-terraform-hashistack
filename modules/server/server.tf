
resource "random_id" "gossip_key" {
  byte_length = 32
}

resource "digitalocean_droplet" "server" {
  count     = var.cluster_size
  name      = "server-${count.index}"
  image     = "debian-11-x64"
  region    = var.region
  size      = var.node_size
  ssh_keys  = [digitalocean_ssh_key.default.fingerprint]
  tags      = var.tags
  vpc_uuid  = var.vpc_id
  user_data = file("${path.module}/config/cloud-init")

  # Wait for cloud-init to finish (see user_data above)
  # https://github.com/hashicorp/terraform/issues/4668#issuecomment-419575242
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    agent       = true
    timeout     = "1m"
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    content = templatefile("${path.module}/config/consul/consul.tftpl", {
      # Nomad is only listening on the private network
      # In order to connect to Nomad from outside the private network 
      # you must use SSH port forwarding.
      # 
      # Example: ssh -N -L 4646:{PRIVATE_IP}:4646 root@{PUBLIC_IP}
      bind_addr    = self.ipv4_address_private
      gossip_key   = random_id.gossip_key.b64_std
      join_addr    = digitalocean_droplet.server.0.ipv4_address_private
      datacenter   = var.datacenter
      cluster_size = var.cluster_size
      region       = var.region
      index        = count.index
    })
    destination = "/etc/consul.d/consul.hcl"
  }

  # provisioner "file" {
  #   content = templatefile("${path.module}/config/nomad/nomad.tftpl", {
  #     # Nomad is only listening on the private network
  #     # In order to connect to Nomad from outside the private network 
  #     # you must use SSH port forwarding.
  #     # 
  #     # Example: ssh -N -L 4646:{PRIVATE_IP}:4646 root@{PUBLIC_IP}
  #     bind_addr    = self.ipv4_address_private
  #     gossip_key   = random_id.gossip_key.b64_std
  #     join_addr    = digitalocean_droplet.server.0.ipv4_address_private
  #     datacenter   = var.datacenter
  #     cluster_size = var.cluster_size
  #     region       = var.region
  #   })
  #   destination = "/etc/nomad.d/nomad.hcl"
  # }

  # Copy over the ca certificate for TLS
  # provisioner "file" {
  #   content     = file(var.ca_cert_path)
  #   destination = "/etc/nomad.d/ca.pem"
  # }

  provisioner "file" {
    content     = file(var.ca_cert_path)
    destination = "/etc/consul.d/ca.pem"
  }

  # Copy over the server certificate for TLS
  # provisioner "file" {
  #   content     = file(var.nomad_server_cert)
  #   destination = "/etc/nomad.d/server.pem"
  # }

  provisioner "file" {
    content     = file(var.consul_server_cert[count.index])
    destination = "/etc/consul.d/server${count.index}.pem"
  }

  # Copy over the server key for TLS
  provisioner "file" {
    content     = file(var.consul_server_key[count.index])
    destination = "/etc/consul.d/server${count.index}-key.pem"
  }

  # provisioner "file" {
  #   content     = file(var.nomad_server_key)
  #   destination = "/etc/nomad.d/server-key.pem"
  # }

  # Copy over the systemd config
  # provisioner "file" {
  #   content     = file("${path.module}/config/nomad/nomad.service")
  #   destination = "/etc/systemd/system/nomad.service"
  # }

  provisioner "file" {
    content     = file("${path.module}/config/consul/consul.service")
    destination = "/etc/systemd/system/consul.service"
  }

  provisioner "remote-exec" {
    inline = [
      # Enable the consul service on boot
      "systemctl enable consul.service",
      # Start the consul service
      "systemctl start consul.service"
    ]
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     # Enable the nomad service on boot
  #     "systemctl enable nomad.service",
  #     # Start the nomad service
  #     "systemctl start nomad.service"
  #   ]
  # }

  depends_on = [
    digitalocean_ssh_key.default
  ]
}
