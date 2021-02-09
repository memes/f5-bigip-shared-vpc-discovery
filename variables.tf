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
The GCP project identifier of the Shared VPC Host project that will contain the
shared VPC networks, and BIG-IP instances.
EOD
}

variable "region" {
  type        = string
  default     = "us-west1"
  description = <<EOD
The region to deploy test resources. Default is 'us-west1'.
EOD
}

variable "base_cidr" {
  type        = string
  default     = "172.16.0.0/12"
  description = <<EOD
The base CIDR that will be used for all VPC networks.
EOD
}

variable "vpc_cidr_size" {
  type        = number
  default     = 17
  description = <<EOD
The target CIDR size for each VPC network. Default is 17.

E.g. if there are three environments (dev, test, and prod), then 5 VPCs will be
created each with a /17 CIDR block out of the 172.16.0.0/12 range specified in
`base_cidr`.
EOD
}

variable "num_bigips" {
  type        = number
  default     = 1
  description = <<EOD
The number of BIG-IP instances to run. Default is 1.
EOD
}

variable "bigip_machine_type" {
  type    = string
  default = "n2-standard-8"
}

variable "bigip_min_cpu_platform" {
  type    = string
  default = "Intel Cascade Lake"
}

variable "bigip_image" {
  type        = string
  default     = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-2-1-0-0-10-payg-good-25mbps-210115160742"
  description = <<EOD
The BIG-IP image to use; default is a v15.1.2.1 PAYG licensed GOOD/25MBps image.
EOD
}

variable "environments" {
  type = map(object({
    service_project_id = string
  }))
  description = <<EOD
A map of environment names to the parameters that will drive creation of VPC networks for
discoverable backend services.

E.g. to simulate a beta and prod pair of environments:

environments = {
  beta = {
    service_project_id = "beta-service-project-id"
    num_instances = 1
  },
  prod = {
    service_project_id = "prod-service-project-id"
  }
}
EOD
}
