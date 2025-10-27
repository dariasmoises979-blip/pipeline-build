output "instance_names" {
  value       = [for inst in google_compute_instance.docker_instance : inst.name]
  description = "Nombres de las instancias creadas"
}

output "instance_ips" {
  value       = [for inst in google_compute_instance.docker_instance : inst.network_interface[0].access_config[0].nat_ip]
  description = "IPs públicas de las instancias"
}
