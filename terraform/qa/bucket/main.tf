#----------------------------------
# Terraform configuration for QA S3 Bucket
#----------------------------------

module "gcp_bucket_qa" {
  source        = "../../modules/gcp/bucket" # Path to the GCP bucket module
  bucket_name   = var.bucket_name       # Name of the bucket for QA environment
  location      = var.qa_bucket_location   # Location/region of the bucket for QA environment
  force_destroy = var.qa_force_destroy     # Whether to force destroy the bucket for QA environment
  project_id    = var.gcp_project_id       # GCP Project ID
  user_email    = var.qa_bucket_user_email # User email to be granted access to the bucket
}

output "qa_bucket_name" {
  description = "The name of the QA GCP Storage Bucket"
  value       = module.gcp_bucket_qa.bucket_name
}

output "qa_bucket_url" {
  description = "The URL of the QA GCP Storage Bucket"
  value       = module.gcp_bucket_qa.bucket_url
}

output "qa_bucket_location" {
  description = "The location/region of the QA GCP Storage Bucket"
  value       = module.gcp_bucket_qa.bucket_location
}

output "qa_bucket_id" {
  description = "The ID of the QA GCP Storage Bucket"
  value       = module.gcp_bucket_qa.id
}

