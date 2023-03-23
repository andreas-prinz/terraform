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

resource "libvirt_network" "network1" {
  name      = "net1"
  autostart = true
  mode      = "nat"
  domain    = "net1.local"
  addresses = ["10.0.1.0/24", "fde8:ab1:bc2:1::/64"]
  dns {
    enabled    = false
    local_only = true
  }
}

resource "libvirt_pool" "cluster1" {
  name = "clust1"
  type = "dir"
  path = "/opt/qemu/clust1"
}

resource "libvirt_volume" "server1" {
  name   = "srv1"
  pool   = libvirt_pool.cluster1.name
  source = "https://cloud.debian.org/images/cloud/sid/daily/latest/debian-sid-genericcloud-amd64-daily.qcow2"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = ${file("${path.module}/data/user_data.cfg")}
  vars = {
    domain_name = "srv1"
  }
}

data "template_file" "network_config" {
  template = ${file("${path.module}/data/network_config.cfg")}
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "srv1_cloudinit"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.cluster1.name
}

resource "libvirt_domain" "server1" {
  name   = "srv1"
  memory = "1024"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id
  
  network_interface {
    network_name = libvirt_network.network1.name
  }
  
  disk {
    volume_id = libvirt_volume.server1.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  
  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
