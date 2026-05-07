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

module "compute_subnetwork" {
  source = "./modules/compute_subnetwork"
  name = "base-infra-subnet"
  ip_cidr_range = "10.1.0.0/24"
  cn_id = module.compute_network.cn_id
}