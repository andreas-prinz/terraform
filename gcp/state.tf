# main.tf
provider "google" {
  project     = "# REPLACE WITH YOUR PROJECT ID"
  region      = "us-central-1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "# REPLACE WITH YOUR BUCKET NAME"
  location    = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}

terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
#   backend "gcs" {
#     bucket  = "# REPLACE WITH YOUR BUCKET NAME"
#     prefix  = "terraform/state"
#   }
}
