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

module "compute_firewall_bastion" {
  source = "./modules/compute_firewall"
  name = "base-infra-bastion-fw"
  cn_id = module.compute_network.cn_id
  target_tags = ["bastion"]
  source_ranges = ["0.0.0.0/0"]
  protocol = "tcp"
  ports = ["22"]
}

module "container_cluster" {
  source = "./modules/container_cluster"
  location = "${var.region}-a"
  name = "base-infra-cluster"
  initial_node_count = 1
  remove_default_node_pool = true
  cn_id = module.compute_network.cn_id
  scn_id = module.compute_subnetwork_cluster.scn_id
  networking_mode = "VPC_NATIVE"
  deletion_protection = false
}

module "container_node_pool" {
  source = "./modules/container_node_pool"
  name = "base-infra-node-pool"
  cluster_id = module.container_cluster.cluster_id
  node_count = 1
  machine_type = "e2-micro"
}