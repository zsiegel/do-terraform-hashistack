output "ca_cert_path" {
  value = local_file.ca_cert.filename
}

output "nomad_server_cert_path" {
  value = local_file.server_cert.filename
}

output "nomad_server_key_path" {
  value = local_file.server_key.filename
}

output "nomad_client_cert_path" {
  value = local_file.client_cert.filename
}

output "nomad_client_key_path" {
  value = local_file.client_key.filename
}

output "consul_server_cert_path" {
  value = local_file.consul_server_cert.*.filename
}

output "consul_server_key_path" {
  value = local_file.consul_server_key.*.filename
}
