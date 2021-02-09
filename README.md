# repo-template

<!-- spell-checker: ignore markdownlint -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.48 |
| google | ~> 3.48 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.48 ~> 3.48 |
| google.executor | ~> 3.48 ~> 3.48 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environments | A map of environment names to the parameters that will drive creation of VPC networks for<br>discoverable backend services.<br><br>E.g. to simulate a beta and prod pair of environments:<br><br>environments = {<br>  beta = {<br>    service\_project\_id = "beta-service-project-id"<br>    num\_instances = 1<br>  },<br>  prod = {<br>    service\_project\_id = "prod-service-project-id"<br>  }<br>} | <pre>map(object({<br>    service_project_id = string<br>  }))</pre> | n/a | yes |
| shared\_vpc\_host\_project\_id | The GCP project identifier of the Shared VPC Host project that will contain the<br>shared VPC networks, and BIG-IP instances. | `string` | n/a | yes |
| base\_cidr | The base CIDR that will be used for all VPC networks. | `string` | `"172.16.0.0/12"` | no |
| bigip\_image | The BIG-IP image to use; default is a v15.1.2.1 PAYG licensed GOOD/25MBps image. | `string` | `"projects/f5-7626-networks-public/global/images/f5-bigip-15-1-2-1-0-0-10-payg-good-25mbps-210115160742"` | no |
| bigip\_machine\_type | n/a | `string` | `"n2-standard-8"` | no |
| bigip\_min\_cpu\_platform | n/a | `string` | `"Intel Cascade Lake"` | no |
| num\_bigips | The number of BIG-IP instances to run. Default is 1. | `number` | `1` | no |
| prefix | The prefix to use when creating resources, default is 'shared-vpc-sd'. Change this<br>value to avoid conflict with other deployments. | `string` | `"shared-vpc-sd"` | no |
| region | The region to deploy test resources. Default is 'us-west1'. | `string` | `"us-west1"` | no |
| tf\_sa\_email | The fully-qualified email address of the Terraform service account to use for<br>resource creation via account impersonation. If left blank, the default, then<br>the invoker's account will be used.<br><br>E.g. if you have permissions to impersonate:<br><br>tf\_sa\_email = "terraform@PROJECT\_ID.iam.gserviceaccount.com" | `string` | `""` | no |
| tf\_sa\_token\_lifetime\_secs | The expiration duration for the service account token, in seconds. This value<br>should be high enough to prevent token timeout issues during resource creation,<br>but short enough that the token is useless replayed later. Default value is 600<br>(10 mins). | `number` | `600` | no |
| vpc\_cidr\_size | The target CIDR size for each VPC network. Default is 17.<br><br>E.g. if there are three environments (dev, test, and prod), then 5 VPCs will be<br>created each with a /17 CIDR block out of the 172.16.0.0/12 range specified in<br>`base_cidr`. | `number` | `17` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
