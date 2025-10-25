variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (qa, staging, production)"
  type        = string
}

variable "app_version" {
  description = "Application version/commit SHA"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-medium"
}

variable "vm_image" {
  description = "VM image to use"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "min_replicas" {
  description = "Minimum number of VM instances in MIG"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of VM instances in MIG"
  type        = number
  default     = 3
}

variable "enable_load_balancer" {
  description = "Enable external load balancer"
  type        = bool
  default     = false
}

variable "use_single_vm" {
  description = "Use single VM instead of MIG (for simple deployments)"
  type        = bool
  default     = true
}
