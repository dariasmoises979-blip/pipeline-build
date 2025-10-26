output "load_balancer_ip" {
  description = "Public IP of the HTTP load balancer"
  value       = google_compute_global_address.lb_ip.address
}

output "instance_group_name" {
  value = google_compute_region_instance_group_manager.igm.name
}
