# This is required for Terraform 0.13+
terraform {
  required_providers {
    example = {
      version = "~> 1.0.2"
      source  = "example.com/qwiklabs/example"
    }
  }
}

resource "example_server" "my-server" {
  address = "1.2.3.4"
}
