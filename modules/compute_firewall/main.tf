resource "google_compute_firewall" "this" {
  name          = var.name
  network       = var.cn_id
  source_ranges = var.source_ranges
  target_tags   = var.target_tags
  allow {
    protocol = var.protocol
    ports    = var.ports
  }
}