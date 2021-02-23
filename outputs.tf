output "external" {
  value       = module.bigip.external_public_ips
  description = <<EOD
The reservered public IP addresses for services defined on BIG-IPs.
EOD
}

output "management" {
  value       = module.bigip.management_public_ips
  description = <<EOD
The public IP addresses for BIG-IP management.
EOD
}
