resource "google_compute_instance" "docker_instance" {
  count        = var.instance_count
  name         = "${var.name}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  network_interface {
    network = var.network
    access_config {}
  }

  metadata = var.metadata
  tags     = var.tags
}
