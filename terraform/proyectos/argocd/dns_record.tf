data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}

resource "google_dns_record_set" "argocd" {
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.argocd.name
  rrdatas      = [data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip]
}

