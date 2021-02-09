variable "project_id" {
  type        = string
  description = <<EOD
The GCP Project ID for these backend instances.
EOD
}

variable "region" {
  type        = string
  description = <<EOD
The GCP Compute Region in which the backend instances will be deployed.
EOD
}

variable "prefix" {
  type        = string
  description = <<EOD
A prefix value to prepend to all generated resources.
EOD
}

variable "environment" {
  type        = string
  description = <<EOD
An environment identifier to use for backend service web page. E.g. 'dev', 'test',
etc.
EOD
}

variable "num_instances" {
  type        = number
  default     = 2
  description = <<EOD
The number of backend instances to provision. Default is 2.
EOD
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = <<EOD
The GCP Compute machine type to use for these backend services. Default is
'e2-micro'.
EOD
}

variable "image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
  description = <<EOD
The Compute image to use for backend instances. Default is latest public
Ubuntu 20.04 LTS image.
EOD
}

variable "subnet" {
  type        = string
  description = <<EOD
The GCP subnetwork self-link to which these backend instances will be attached.
EOD
}

variable "provision_public_ip" {
  type        = bool
  default     = true
  description = <<EOD
If true (default), a public internet address will be attached to the instance(s).
EOD
}

variable "labels" {
  type        = map(string)
  description = <<EOD
A map of key:value pairs to be associated with instances as `labels`. A value
suitable for service discovery must be present.
EOD
}

variable "tags" {
  type        = list(string)
  default     = []
  description = <<EOD
An optional list of network tags to apply to the instances. Default is empty.
EOD
}
