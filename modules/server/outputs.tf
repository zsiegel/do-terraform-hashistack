output "bind_addr" {
  value = digitalocean_droplet.server[0].ipv4_address_private
}

output "servers" {
  value = digitalocean_droplet.server.*.id
}

output "ip" {
  value = digitalocean_droplet.server.*.ipv4_address
}
