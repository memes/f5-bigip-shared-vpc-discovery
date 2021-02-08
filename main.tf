#


# Generate a BIG-IP service account to use with the VM.
module "bigip_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "3.0.1"
  project_id = var.shared_vpc_host_project_id
  prefix     = var.prefix
  names      = ["bigip-vm"]
  project_roles = [
    "${var.shared_vpc_host_project_id}=>roles/logging.logWriter",
    "${var.shared_vpc_host_project_id}=>roles/monitoring.metricWriter",
    "${var.shared_vpc_host_project_id}=>roles/monitoring.viewer",
  ]
  generate_keys = false
}

# Generate a service account in the Shared VPC Service project that has ability
# to view attributes of VMs.
module "discovery_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "3.0.1"
  project_id = var.shared_vpc_service_project_id
  prefix     = var.prefix
  names      = ["bigip-sd"]
  project_roles = [
    "${var.shared_vpc_service_project_id}=>roles/compute.viewer",
  ]
  generate_keys = true
}

locals {
  bigip_vm_sa = format("%s-bigip-vm@%s.iam.gserviceaccount.com", var.prefix, var.shared_vpc_host_project_id)
  bigip_sd_sa = format("%s-bigip-sd@%s.iam.gserviceaccount.com", var.prefix, var.shared_vpc_service_project_id)
}


module "bigip_passwd" {
  source     = "memes/secret-manager/google//modules/random"
  version    = "1.0.2"
  project_id = var.shared_vpc_host_project_id
  id         = format("%s-bigip-admin-key", var.prefix)
  accessors = [
    format("serviceAccount:%s", local.bigip_vm_sa)
  ]
  length           = 16
  special_char_set = "@#%&*()-_=+[]<>:?"
}
