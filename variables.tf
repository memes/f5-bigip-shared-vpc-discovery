variable "tf_sa_email" {
  type        = string
  default     = ""
  description = <<EOD
The fully-qualified email address of the Terraform service account to use for
resource creation via account impersonation. If left blank, the default, then
the invoker's account will be used.

E.g. if you have permissions to impersonate:

tf_sa_email = "terraform@PROJECT_ID.iam.gserviceaccount.com"
EOD
}

variable "tf_sa_token_lifetime_secs" {
  type        = number
  default     = 600
  description = <<EOD
The expiration duration for the service account token, in seconds. This value
should be high enough to prevent token timeout issues during resource creation,
but short enough that the token is useless replayed later. Default value is 600
(10 mins).
EOD
}

variable "prefix" {
  type        = string
  default     = "shared-vpc-sd"
  description = <<EOD
The prefix to use when creating resources, default is 'shared-vpc-sd'. Change this
value to avoid conflict with other deployments.
EOD
}

variable "shared_vpc_host_project_id" {
  type        = string
  description = <<EOD
The GCP project identifier of the Shared VPC Host project that will define
networks.
EOD
}

variable "shared_vpc_service_project_id" {
  type        = string
  description = <<EOD
The GCP project identifier of the Shared VPC Service project that will contain
backend services attached to a `Shared VPC Host` network.
EOD
}

variable "region" {
  type        = string
  default     = "us-west1"
  description = <<EOD
The region to deploy test resources. Default is 'us-west1'.
EOD
}

variable "external_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = <<EOD
The CIDR to use for External facing subnet. Default is '172.16.0.0/16'.
EOD
}

variable "management_cidr" {
  type        = string
  default     = "172.17.0.0/16"
  description = <<EOD
The CIDR to use for management facing subnet. Default is '172.17.0.0/16'.
EOD
}

variable "dev_cidr" {
  type        = string
  default     = "172.18.0.0/16"
  description = <<EOD
The CIDR to use for dev subnet. Default is '172.18.0.0/16'.
EOD
}

variable "test_cidr" {
  type        = string
  default     = "172.19.0.0/16"
  description = <<EOD
The CIDR to use for External facing subnet. Default is '172.19.0.0/16'.
EOD
}
