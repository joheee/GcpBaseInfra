resource "google_container_cluster" "this" {
    location = var.location
    name = var.name
    initial_node_count = var.initial_node_count
    remove_default_node_pool = var.remove_default_node_pool
    network = var.cn_id
    subnetwork = var.scn_id
    networking_mode = var.networking_mode
    deletion_protection =  var.deletion_protection
}