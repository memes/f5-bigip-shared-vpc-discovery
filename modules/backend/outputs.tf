output "vm_service_account" {
  value       = module.vm_sa.email
  description = <<EOD
The service account that is used by this backend service.
EOD
}

output "discovery_service_account" {
  value       = module.discovery_sa.email
  description = <<EOD
A service account that can perform service discovery API calls in project used
by the backend.
EOD
}

output "discovery_service_account_credentials" {
  value       = module.discovery_sa.key
  description = <<EOD
JSON service account credentials for service discovery account.
EOD
}
