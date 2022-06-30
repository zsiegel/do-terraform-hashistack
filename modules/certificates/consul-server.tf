
resource "tls_private_key" "consul_server_key" {
  count       = var.cluster_size
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "consul_server_cert_file" {
  count    = var.cluster_size
  content  = tls_private_key.consul_server_key[count.index].private_key_pem
  filename = "${var.certs_dir}/consul/server/server${count.index + 1}-private-key.pem"
}

resource "tls_cert_request" "consul_server_cert_request" {
  count           = var.cluster_size
  private_key_pem = tls_private_key.consul_server_key[count.index].private_key_pem

  dns_names    = ["localhost", "server.${var.datacenter}.consul"]
  ip_addresses = ["127.0.0.1"]
  subject {
    organization = var.organization
    common_name  = "server.${var.datacenter}.consul"
  }
}

resource "tls_locally_signed_cert" "consul_server_signed_cert" {
  count            = var.cluster_size
  cert_request_pem = tls_cert_request.consul_server_cert_request[count.index].cert_request_pem

  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  set_subject_key_id = true

  validity_period_hours = var.certificate_validity
  allowed_uses          = ["key_encipherment", "digital_signature", "server_auth", "client_auth"]
}

# resource "local_file" "consul_server_cert_csr" {
#   content  = tls_cert_request.consul_server_cert_request.cert_request_pem
#   filename = "${var.certs_dir}/consul/server/server-csr.pem"
# }

resource "local_file" "consul_server_cert" {
  count    = var.cluster_size
  content  = tls_locally_signed_cert.consul_server_signed_cert[count.index].cert_pem
  filename = "${var.certs_dir}/consul/server/server${count.index + 1}-cert.pem"
}

resource "local_file" "consul_server_key" {
  count    = var.cluster_size
  content  = tls_private_key.consul_server_key[count.index].private_key_pem
  filename = "${var.certs_dir}/consul/server/server${count.index + 1}-key.pem"
}

