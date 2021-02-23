# Backend service module

Creates a _backend service_ for named environment in specified project.

<!-- spell-checker: ignore markdownlint -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.5 |
| google | >= 3.55 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.55 |
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| discovery_sa | terraform-google-modules/service-accounts/google | 3.0.1 |
| vm_sa | terraform-google-modules/service-accounts/google | 3.0.1 |

## Resources

| Name |
|------|
| [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/3.55/docs/resources/compute_instance) |
| [google_compute_zones](https://registry.terraform.io/providers/hashicorp/google/3.55/docs/data-sources/compute_zones) |
| [random_shuffle](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | An environment identifier to use for backend service web page. E.g. 'dev', 'test',<br>etc. | `string` | n/a | yes |
| labels | A map of key:value pairs to be associated with instances as `labels`. A value<br>suitable for service discovery must be present. | `map(string)` | n/a | yes |
| prefix | A prefix value to prepend to all generated resources. | `string` | n/a | yes |
| project\_id | The GCP Project ID for these backend instances. | `string` | n/a | yes |
| region | The GCP Compute Region in which the backend instances will be deployed. | `string` | n/a | yes |
| subnet | The GCP subnetwork self-link to which these backend instances will be attached. | `string` | n/a | yes |
| image | The Compute image to use for backend instances. Default is latest public<br>Ubuntu 20.04 LTS image. | `string` | `"ubuntu-os-cloud/ubuntu-2004-lts"` | no |
| machine\_type | The GCP Compute machine type to use for these backend services. Default is<br>'e2-micro'. | `string` | `"e2-micro"` | no |
| num\_instances | The number of backend instances to provision. Default is 2. | `number` | `2` | no |
| provision\_public\_ip | If true (default), a public internet address will be attached to the instance(s). | `bool` | `true` | no |
| tags | An optional list of network tags to apply to the instances. Default is empty. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| discovery\_service\_account | A service account that can perform service discovery API calls in project used<br>by the backend. |
| discovery\_service\_account\_credentials | JSON service account credentials for service discovery account. |
| vm\_service\_account | The service account that is used by this backend service. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
