
resource "tls_private_key" "client_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "local_file" "client_cert_file" {
  content  = tls_private_key.client_key.private_key_pem
  filename = "${var.certs_dir}/client/client-private-key.pem"
}

resource "tls_cert_request" "client_cert_request" {
  private_key_pem = tls_private_key.client_key.private_key_pem

  dns_names    = ["localhost", "client.${var.region}.nomad"]
  ip_addresses = ["127.0.0.1"]
  subject {
    organization = var.organization
  }
}

resource "tls_locally_signed_cert" "client_signed_cert" {
  cert_request_pem = tls_cert_request.client_cert_request.cert_request_pem

  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = var.certificate_validity
  allowed_uses          = ["key_encipherment", "digital_signature", "server_auth", "client_auth"]
}


resource "local_file" "client_cert_csr" {
  content  = tls_cert_request.client_cert_request.cert_request_pem
  filename = "${var.certs_dir}/client/client-csr.pem"
}

resource "local_file" "client_cert" {
  content  = tls_locally_signed_cert.client_signed_cert.cert_pem
  filename = "${var.certs_dir}/client/client-cert.pem"
}

resource "local_file" "client_key" {
  content  = tls_private_key.client_key.private_key_pem
  filename = "${var.certs_dir}/client/client-key.pem"
}

