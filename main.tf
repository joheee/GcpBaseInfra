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

module "compute_subnetwork_cluster" {
  source = "./modules/compute_subnetwork"
  name = "base-infra-cluster-subnet"
  ip_cidr_range = "10.1.0.0/24"
  cn_id = module.compute_network.cn_id
}

module "compute_subnetwork_bastion" {
  source = "./modules/compute_subnetwork"
  name = "base-infra-bastion-subnet"
  ip_cidr_range = "10.1.1.0/24"
  cn_id = module.compute_network.cn_id
}

module "compute_instance_bastion" {
  source = "./modules/compute_instance"
  name = "base-infra-bastion-vm"
  machine_type = "e2-micro"
  zone = "asia-southeast1-a"
  image = "debian-cloud/debian-13"
  oslogin = "TRUE"
  cn_id = module.compute_network.cn_id
  scn_id = module.compute_subnetwork_bastion.scn_id
  tags = ["bastion"]
}