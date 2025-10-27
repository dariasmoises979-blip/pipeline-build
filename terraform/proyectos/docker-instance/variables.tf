variable "project" {
  description = "GCP project id"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Machine type for the instance template (cheapest reasonable: e2-micro)"
  type        = string
  default     = "e2-micro"
}

variable "instance_count" {
  description = "Number of instances in the managed group (min 1 for availability)"
  type        = number
  default     = 1
}

variable "git_repo_url" {
  description = "Git repository URL to clone (replace with your repo)"
  type        = string
  default     = "<REPO_GIT_URL_AQUI>"
}

variable "repo_subdir" {
  description = "Subdirectory to run 'make up' from (relative to repo root). If root, leave empty."
  type        = string
  default     = ""
}

variable "service_port" {
  description = "Port where the app listens (must match your app)"
  type        = number
  default     = 80
}
