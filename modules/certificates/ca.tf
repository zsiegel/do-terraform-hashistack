
resource "tls_private_key" "ca_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem   = tls_private_key.ca_key.private_key_pem
  is_ca_certificate = true

  validity_period_hours = var.certificate_validity

  subject {
    common_name  = var.common_name
    organization = var.organization
  }

  allowed_uses = ["key_encipherment", "digital_signature", "cert_signing"]
}

resource "local_file" "ca_cert" {
  content  = tls_self_signed_cert.ca_cert.cert_pem
  filename = "${var.certs_dir}/ca/ca.pem"
}

resource "local_file" "ca_key" {
  content  = tls_private_key.ca_key.private_key_pem
  filename = "${var.certs_dir}/ca/ca-key.pem"
}
