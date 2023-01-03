# main.tf
provider "docker" {
#  host = "unix:///var/run/docker.sock"
}

# terraform.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.17.0"
    }
  }

  required_version = ">= 1.2"
}

# docker.tf
# docker_container.web:
resource "docker_container" "web" {
    image             = docker_image.nginx.latest
    name              = "hashicorp-learn"
    ports {
        external = 8081
        internal = 80
        ip       = "0.0.0.0"
        protocol = "tcp"
    }
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
}
