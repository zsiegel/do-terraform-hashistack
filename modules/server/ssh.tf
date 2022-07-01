
resource "digitalocean_ssh_key" "default" {
  name       = "ssh-key"
  public_key = file(var.ssh_key)
}
