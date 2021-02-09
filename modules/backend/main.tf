terraform {
  required_version = "~> 0.14.5"
  required_providers {
    google = ">= 3.55"
  }
}

# Generate a service account for the backend service
module "vm_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "3.0.1"
  project_id = var.project_id
  prefix     = var.prefix
  names      = [format("backend-%s", var.environment)]
  project_roles = [
    "${var.project_id}=>roles/logging.logWriter",
    "${var.project_id}=>roles/monitoring.metricWriter",
    "${var.project_id}=>roles/monitoring.viewer",
  ]
  generate_keys = false
}

# Create a service account in the project that can perform service discovery
module "discovery_sa" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "3.0.1"
  project_id = var.project_id
  prefix     = var.prefix
  names      = [format("dsc-%s", var.environment)]
  project_roles = [
    "${var.project_id}=>roles/compute.viewer",
  ]
  generate_keys = true
}

data "google_compute_zones" "zones" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

resource "random_shuffle" "zones" {
  input = data.google_compute_zones.zones.names
  keepers = {
    prefix = var.prefix
  }
}

# Launch backend service instance(s)
resource "google_compute_instance" "backend" {
  count       = var.num_instances
  project     = var.project_id
  name        = format("%s-%s-backend-%d", var.prefix, var.environment, count.index)
  description = format("Backend service for %s (%s)", var.environment, var.prefix)
  zone        = element(random_shuffle.zones.result, count.index)
  metadata = {
    enable-oslogin = "TRUE"
    user-data = templatefile("${path.module}/templates/cloud_config.yml", {
      env = var.environment,
    })
  }
  machine_type = var.machine_type
  service_account {
    email = module.vm_sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  boot_disk {
    auto_delete = true
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnet
    dynamic "access_config" {
      for_each = compact(var.provision_public_ip ? ["1"] : [])
      content {}
    }
  }

  labels = var.labels
  tags   = var.tags
}
