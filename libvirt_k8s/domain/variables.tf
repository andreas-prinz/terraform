variable "domain_name" {
  type        = string
  description = "name"
}

variable "domain_memory" {
  type        = string
  description = "mem"
}

variable "domain_vcpu" {
  type        = string
  description = "cpu"
}

variable "pool_name" {
  type        = string
  description = "pool"
}

variable "network_name" {
  type        = string
  description = "network"
}

variable "network_address" {
  type        = string
  description = "address"
}

variable "network_zone" {
  type        = string
  description = "zone"
}

variable "network_bits" {
  type        = string
  description = "bit"
}

variable "network_gateway" {
  type        = string
  description = "gw"
}

variable "ssh_public_key_path" {
  type        = string
  description = "key"
}

variable "source_image" {
  type        = string
  default     = "https://cloud.debian.org/images/cloud/sid/daily/latest/debian-sid-genericcloud-amd64-daily.qcow2"
  description = "img"
}
