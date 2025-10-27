# GKE Producción
gke_cluster_name       = "pro-cluster"
gke_region             = "europe-west1"
gke_node_count         = 3
gke_node_machine_type  = "e2-standard-2"
gke_node_disk_size     = 100
gke_network            = "default"
gke_subnetwork         = "default"

# Docker App Producción
docker_app_count        = 2
docker_app_machine_type = "e2-standard-2"
docker_app_zone         = "europe-west1-b"
docker_app_image        = "debian-cloud/debian-11"
docker_app_disk_size    = 50
