# Stand-up BIG-IP instance(s)

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

# Generate a random password for BIG-IP admin use
module "bigip_passwd" {
  source     = "memes/secret-manager/google//modules/random"
  version    = "1.0.2"
  project_id = var.shared_vpc_host_project_id
  id         = format("%s-bigip-admin-key", var.prefix)
  accessors = [
    # Avoid dependency issue: BIG-IP SA is predictable
    format("serviceAccount:%s-bigip-vm@%s.iam.gserviceaccount.com", var.prefix, var.shared_vpc_host_project_id),
  ]
  length           = 16
  special_char_set = "@#%&*()-_=+[]<>:?"
  #depends_on = [module.bigip_sa]
}

data "google_compute_zones" "host_zones" {
  project = var.shared_vpc_host_project_id
  region  = var.region
  status  = "UP"
}

resource "random_shuffle" "bigip_zones" {
  input = data.google_compute_zones.host_zones.names
  keepers = {
    prefix = var.prefix
  }
}

module "bigip" {
  source                            = "memes/f5-bigip/google"
  version                           = "2.1.0-rc1"
  project_id                        = var.shared_vpc_host_project_id
  num_instances                     = var.num_bigips
  service_account                   = module.bigip_sa.email
  machine_type                      = var.bigip_machine_type
  min_cpu_platform                  = var.bigip_min_cpu_platform
  image                             = var.bigip_image
  zones                             = random_shuffle.bigip_zones.result
  admin_password_secret_manager_key = module.bigip_passwd.secret_id
  external_subnetwork               = element(module.external_vpc.subnets_self_links, 0)
  provision_external_public_ip      = true
  management_subnetwork             = element(module.management_vpc.subnets_self_links, 0)
  provision_management_public_ip    = true
  internal_subnetworks              = flatten([for vpc in module.environment_vpcs : vpc.subnets_self_links])
  provision_internal_public_ip      = false
  as3_payloads = [templatefile("${path.module}/templates/as3.json", {
    vip    = "0.0.0.0/0",
    region = var.region,
    environments = { for k, v in var.environments : k => {
      label_key   = local.service_discovery_key
      label_value = format(local.service_discovery_value_format, k)
      creds       = base64encode(module.backend[k].discovery_service_account_credentials),
    } }
    fallback_environment = element(keys(var.environments), 0)
  })]
}

resource "google_compute_firewall" "bigip_external" {
  project   = var.shared_vpc_host_project_id
  name      = format("%s-ext-allow-bigip-http", var.prefix)
  network   = module.external_vpc.network_self_link
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [module.bigip_sa.email]
}

resource "google_compute_firewall" "bigip_management" {
  project   = var.shared_vpc_host_project_id
  name      = format("%s-mgmt-allow-bigip-admin", var.prefix)
  network   = module.management_vpc.network_self_link
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = [module.bigip_sa.email]
}

resource "google_compute_firewall" "bigip_backend" {
  for_each  = var.environments
  project   = var.shared_vpc_host_project_id
  name      = format("%s-%s-allow-bigip-backend-http", var.prefix, each.key)
  network   = module.environment_vpcs[each.key].network_self_link
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_service_accounts = [module.bigip_sa.email]
  target_service_accounts = [module.backend[each.key].vm_service_account]
}
