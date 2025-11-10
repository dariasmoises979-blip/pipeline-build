#-----------------------------------------
# Terraform Variables for QA S3 Bucket
#-----------------------------------------

variable "bucket_name" {
  description = "Name of the GCS bucket for QA environment"
  type        = string
}

variable "qa_bucket_location" {
  description = "Location/region of the bucket for QA environment"
  type        = string
  default     = "US"
}

variable "qa_force_destroy" {
  description = "Whether to force destroy the bucket (deletes all objects) for QA environment"
  type        = bool
  default     = false
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "qa_bucket_user_email" {
  description = "User email to be granted access to the QA bucket"
  type        = string
}

variable "gcp_credentials_file" {
  description = "Path to the GCP service account credentials JSON file"
  type        = string
}

locals {
    gcp_project_id    = var.gcp_project_id  # Use the variable value
    gcp_region        = "us-central1"       # Replace with your desired GCP region
    gcp_credentials_file  = ""
    gcp_tags    = {
        Environment = "QA"
        Team        = "DevOps"
        Project     = "MyProject"
    }
}