terraform {
  backend "gcs" {
    bucket = "upwork-terraform"
    prefix = "gcp-base-infra"
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

module "compute_network" {
  source = "./modules/compute_network"
  name = "base-infra-vpc"
}