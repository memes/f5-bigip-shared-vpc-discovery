# Shared VPC networks for external, management, and two networks for dev and test
# services. No NAT, so make sure instances needing to pull from public internet
# have public IP addresses.


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
      subnet_ip             = local.subnet_cidrs["external"]
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
      subnet_ip             = local.subnet_cidrs["management"]
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}

module "environment_vpcs" {
  for_each                               = var.environments
  source                                 = "terraform-google-modules/network/google"
  version                                = "3.0.1"
  project_id                             = var.shared_vpc_host_project_id
  network_name                           = format("%s-%s", var.prefix, each.key)
  description                            = format("Shared VPC network for %s backends (%s)", each.key, var.prefix)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  routing_mode                           = "REGIONAL"
  subnets = [
    {
      subnet_name           = format("%s-%s-%s", var.prefix, each.key, local.short_region)
      subnet_ip             = local.subnet_cidrs[each.key]
      subnet_region         = var.region
      subnet_private_access = false
    },
  ]
}
