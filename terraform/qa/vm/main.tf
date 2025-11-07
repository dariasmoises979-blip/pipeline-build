# Inicializa backend (remoto definido en ../backend.tf)
terraform {
  required_version = ">= 1.6.0"
}

# ==========================================================
# Módulo GKE para QA
# ==========================================================
module "gke_qa" {
  source          = "../modules/gke"
  cluster_name    = var.gke_cluster_name
  region          = var.gke_region
  node_count      = var.gke_node_count
  node_machine_type = var.gke_node_machine_type
  node_disk_size  = var.gke_node_disk_size
  network         = var.gke_network
  subnetwork      = var.gke_subnetwork
}

# ==========================================================
# Módulo Docker Instances para QA
# ==========================================================
module "docker_app_qa" {
  source         = "../modules/docker-instance"
  name           = "qa-app"
  instance_count = var.docker_app_count
  machine_type   = var.docker_app_machine_type
  zone           = var.docker_app_zone
  image          = var.docker_app_image
  disk_size      = var.docker_app_disk_size
}
