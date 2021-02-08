# Shared VPC networks for external, management, and two networks for dev and test
# services.

locals {
  short_region = replace(var.region, "/^[^-]+-([^0-9-]+)[0-9]$/", "$1")
}

module "external_vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.shared_vpc_host_project_id
  network_name                           = format("%s-external", var.prefix)
  description                            = "External VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-external-%s", var.prefix, local.short_region)
      subnet_ip             = var.external_cidr
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}

module "management_vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.shared_vpc_host_project_id
  network_name                           = format("%s-management", var.prefix)
  description                            = "Management VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-management-%s", var.prefix, local.short_region)
      subnet_ip             = var.management_cidr
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}

module "dev_vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.shared_vpc_host_project_id
  network_name                           = format("%s-dev", var.prefix)
  description                            = "DEV VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-dev-%s", var.prefix, local.short_region)
      subnet_ip             = var.dev_cidr
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}

module "test_vpc" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.shared_vpc_host_project_id
  network_name                           = format("%s-test", var.prefix)
  description                            = "Test VPC"
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-test-%s", var.prefix, local.short_region)
      subnet_ip             = var.test_cidr
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}

module "nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "1.3.0"
  project_id                         = var.shared_vpc_host_project_id
  region                             = var.region
  name                               = format("%s-mgmt-router-nat-%s", var.prefix, local.short_region)
  router                             = format("%s-int-router-%s", var.prefix, local.short_region)
  create_router                      = true
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  network                            = module.management_vpc.network_self_link
  subnetworks = [
    {
      name                     = element(module.management_vpc.subnets_self_links, 0)
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    },
  ]
}
