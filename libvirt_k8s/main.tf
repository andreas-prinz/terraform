terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  project_name   = "k8s"
  network_domain = "net1.local"
  network_mask   = "10.0.1.0"
  network_gw     = "10.0.1.1"
  network_bits   = 24
}

resource "libvirt_network" "network1" {
  name      = local.project_name
  autostart = true
  mode      = "nat"
  domain    = local.network_domain
  addresses = ["${local.network_mask}/${local.network_bits}"]
  dns {
    enabled    = true
    local_only = true
  }
}

resource "libvirt_pool" "cluster1" {
  name = local.project_name
  type = "dir"
  path = "/opt/qemu/${local.project_name}"
}

module "masters" {
  count         = 2
  source        = "./domain"
  domain_name   = "${local.network_domain}-master${count.index}"
  domain_memory = "2048"
  domain_vcpu   = "2"

  pool_name       = libvirt_pool.cluster1.name
  network_name    = libvirt_network.network1.name
  network_zone    = local.network_domain
  network_address = cdirhost("${local.network_mask}/${local.network_bits}", sum([10, count.index]))
  network_bits    = local.network_bits
  network_gateway = local.network_gw
  
  source_image        = "/opt/qemu/images/debian-sid-genericcloud-amd64-daily.qcow2"
  ssh_public_key_path = "/opt/qemu/ssh/id_rsa.pub"
}

module "workers" {
  count         = 3
  source        = "./domain"
  domain_name   = "${local.network_domain}-worker${count.index}"
  domain_memory = "2048"
  domain_vcpu   = "2"

  pool_name       = libvirt_pool.cluster1.name
  network_name    = libvirt_network.network1.name
  network_zone    = local.network_domain
  network_address = cdirhost("${local.network_mask}/${local.network_bits}", sum([20, count.index]))
  network_bits    = local.network_bits
  network_gateway = local.network_gw
  
  source_image        = "/opt/qemu/images/debian-sid-genericcloud-amd64-daily.qcow2"
  ssh_public_key_path = "/opt/qemu/ssh/id_rsa.pub"
}
