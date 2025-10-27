resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-nodes"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  depends_on = [google_container_cluster.primary]
}
