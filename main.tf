#

locals {
  service_discovery_key          = "f5-service-discovery"
  service_discovery_value_format = format("%s-%%s", var.prefix)
  short_region                   = replace(var.region, "/^[^-]+-([^0-9-]+)[0-9]$/", "$1")
  subnet_cidr_offset             = var.vpc_cidr_size - tonumber(replace(var.base_cidr, "/^.*\\//", ""))
  subnet_cidrs = merge(
    {
      external   = cidrsubnet(var.base_cidr, local.subnet_cidr_offset, 0),
      management = cidrsubnet(var.base_cidr, local.subnet_cidr_offset, 1),
    },
    { for k, v in var.environments :
      k => cidrsubnet(var.base_cidr, local.subnet_cidr_offset, 2 + index(keys(var.environments), k))
    },
  )
}

module "backend" {
  for_each      = var.environments
  source        = "./modules/backend/"
  project_id    = each.value.service_project_id
  region        = var.region
  prefix        = var.prefix
  environment   = each.key
  num_instances = lookup(each.value, "num_instances", 2)
  subnet        = element(module.environment_vpcs[each.key].subnets_self_links, 0)
  labels = {
    (local.service_discovery_key) = format(local.service_discovery_value_format, each.key)
  }
}
