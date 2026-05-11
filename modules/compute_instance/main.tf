resource "google_compute_instance" "this" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network    = var.cn_id
    subnetwork = var.scn_id
    access_config {
    }
  }
  metadata = {
    enable-oslogin = var.oslogin
  }
  tags = var.tags
}