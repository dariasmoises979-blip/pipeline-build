variable "cluster_name" {
  type        = string
  description = "Nombre del cluster GKE"
}

variable "region" {
  type        = string
  default     = "europe-west1"
}

variable "node_count" {
  type        = number
  default     = 3
}

variable "node_machine_type" {
  type        = string
  default     = "e2-medium"
}

variable "node_disk_size" {
  type        = number
  default     = 50
}

variable "network" {
  type        = string
  default     = "default"
}

variable "subnetwork" {
  type        = string
  default     = "default"
}
