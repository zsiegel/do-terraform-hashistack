output "ca_cert_path" {
  value = local_file.ca_cert.filename
}

output "server_cert_path" {
  value = local_file.server_cert.filename
}

output "server_key_path" {
  value = local_file.server_key.filename
}

output "client_cert_path" {
  value = local_file.client_cert.filename
}

output "client_key_path" {
  value = local_file.client_key.filename
}
