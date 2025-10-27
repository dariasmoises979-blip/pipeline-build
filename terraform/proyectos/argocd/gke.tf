resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  initial_node_count = 1

  remove_default_node_pool = true

  network = "default"

  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-pool"
  cluster    = google_container_cluster.gke.name
  location   = google_container_cluster.gke.location
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
