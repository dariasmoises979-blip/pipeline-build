output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Nombre del cluster GKE"
}

output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "Endpoint del cluster"
}

output "node_pool_names" {
  value       = [google_container_node_pool.primary_nodes.name]
  description = "Nombres de los Node Pools"
}
