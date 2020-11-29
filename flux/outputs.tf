output "public_key" {
  value       = tls_private_key.flux.public_key_openssh
  description = "Public SSH key for the flux private ssh key secret."
}

output "private_key" {
  value       = tls_private_key.flux.private_key_pem
  description = "Private SSH key for the flux source controller."
  sensitive   = true
}

output "flux_install_path" {
  value       = data.flux_install.main.path
}

output "flux_sync_path" {
  value       = data.flux_sync.main.path
}
