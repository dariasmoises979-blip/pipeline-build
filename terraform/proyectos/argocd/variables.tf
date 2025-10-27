variable "project_id" {
  description = "ID del proyecto de Google Cloud"
  type        = string
}

variable "region" {
  description = "Región de GCP para el cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Nombre del cluster GKE"
  type        = string
  default     = "argocd-cluster"
}

variable "domain_name" {
  description = "Dominio público para Argo CD"
  type        = string
}

variable "dns_zone_name" {
  description = "Nombre de la zona DNS en GCP"
  type        = string
  default     = "argocd-zone"
}
