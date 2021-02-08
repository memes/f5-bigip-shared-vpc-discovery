# repo-template

<!-- spell-checker: ignore markdownlint -->

<!-- markdownlint-disable no-inline-html -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| google | ~> 3.48 |
| google | ~> 3.48 |
| google-beta | ~> 3.48 |

## Providers

| Name | Version |
|------|---------|
| google.executor | ~> 3.48 ~> 3.48 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| shared\_vpc\_host\_project\_id | The GCP project identifier of the Shared VPC Host project that will define<br>networks. | `string` | n/a | yes |
| shared\_vpc\_service\_project\_id | The GCP project identifier of the Shared VPC Service project that will contain<br>backend services attached to a `Shared VPC Host` network. | `string` | n/a | yes |
| dev\_cidr | The CIDR to use for dev subnet. Default is '172.18.0.0/16'. | `string` | `"172.18.0.0/16"` | no |
| external\_cidr | The CIDR to use for External facing subnet. Default is '172.16.0.0/16'. | `string` | `"172.16.0.0/16"` | no |
| management\_cidr | The CIDR to use for management facing subnet. Default is '172.17.0.0/16'. | `string` | `"172.17.0.0/16"` | no |
| prefix | The prefix to use when creating resources, default is 'shared-vpc-sd'. Change this<br>value to avoid conflict with other deployments. | `string` | `"shared-vpc-sd"` | no |
| region | The region to deploy test resources. Default is 'us-west1'. | `string` | `"us-west1"` | no |
| test\_cidr | The CIDR to use for External facing subnet. Default is '172.19.0.0/16'. | `string` | `"172.19.0.0/16"` | no |
| tf\_sa\_email | The fully-qualified email address of the Terraform service account to use for<br>resource creation via account impersonation. If left blank, the default, then<br>the invoker's account will be used.<br><br>E.g. if you have permissions to impersonate:<br><br>tf\_sa\_email = "terraform@PROJECT\_ID.iam.gserviceaccount.com" | `string` | `""` | no |
| tf\_sa\_token\_lifetime\_secs | The expiration duration for the service account token, in seconds. This value<br>should be high enough to prevent token timeout issues during resource creation,<br>but short enough that the token is useless replayed later. Default value is 600<br>(10 mins). | `number` | `600` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable no-inline-html -->
