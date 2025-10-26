resource "google_dns_managed_zone" "argocd" {
  name     = var.dns_zone_name
  dns_name = "${var.domain_name}."
  description = "Managed zone for ArgoCD"
}
