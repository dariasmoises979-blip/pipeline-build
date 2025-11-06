#--------------------------------------------
# Output variables for GCP Bucket module
#--------------------------------------------

output "bucket_name" {
    description = "The name of the GCP Storage Bucket"
    value       = google_storage_bucket.bucket-gcp.name
}

output "bucket_url" {
    description = "The URL of the GCP Storage Bucket"
    value       = "gs://${google_storage_bucket.bucket-gcp.name}"
}

output "bucket_location" {
    description = "The location/region of the GCP Storage Bucket"
    value       = google_storage_bucket.bucket-gcp.location
}

output "id" {
    description = "The ID of the GCP Storage Bucket"
    value       = google_storage_bucket.bucket-gcp.id
  
}