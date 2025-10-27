# GKE QA
gke_cluster_name       = "qa-cluster"
gke_region             = "europe-west1"
gke_node_count         = 2
gke_node_machine_type  = "e2-medium"
gke_node_disk_size     = 50
gke_network            = "default"
gke_subnetwork         = "default"

# Docker App QA
docker_app_count        = 1
docker_app_machine_type = "e2-medium"
docker_app_zone         = "europe-west1-b"
docker_app_image        = "debian-cloud/debian-11"
docker_app_disk_size    = 20
