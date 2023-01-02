# main.tf
provider "google" {
  version = "~> 3.45.0"
}

provider "null" {
  version = "~> 2.1"
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 3.2.0"
  project_id   = var.project_id
#  network_name = "my-custom-mode-network"
  network_name = var.network_name
  mtu          = 1460
  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
}

# variables.tf
# gcloud config list --format 'value(core.project)'
variable "project_id" {
  description = "The project ID to host the network in"
  default     = "FILL IN YOUR PROJECT ID HERE"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "example-vpc"
}

# outputs.tf
output "network_name" {
  value       = module.test-vpc-module.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.test-vpc-module.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.test-vpc-module.project_id
  description = "VPC project id"
}

output "subnets_names" {
  value       = module.test-vpc-module.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.test-vpc-module.subnets_ips
  description = "The IP and cidrs of the subnets being created"
}

output "subnets_regions" {
  value       = module.test-vpc-module.subnets_regions
  description = "The region where subnets will be created"
}

output "subnets_private_access" {
  value       = module.test-vpc-module.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = module.test-vpc-module.subnets_flow_logs
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = module.test-vpc-module.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "route_names" {
  value       = module.test-vpc-module.route_names
  description = "The routes associated with this VPC"
}
