resource "google_container_node_pool" "this" {
  name       = var.name
  cluster    = var.cluster_id
  node_count = var.node_count
  node_config {
    machine_type = var.machine_type
  }
}