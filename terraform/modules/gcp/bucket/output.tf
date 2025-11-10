#-------------------------------------------------
# GCP Bucket Module Outputs
#-------------------------------------------------

output "bucket_name" {
  description = "The name of the bucket"
  value       = google_storage_bucket.bucket-gcp.name
}

output "bucket_url" {
  description = "The URL of the bucket"
  value       = google_storage_bucket.bucket-gcp.url
}

output "bucket_location" {
  description = "The location of the bucket"
  value       = google_storage_bucket.bucket-gcp.location
}

output "id" {
  description = "The ID of the bucket"
  value       = google_storage_bucket.bucket-gcp.id
}

output "self_link" {
  description = "The self link of the bucket"
  value       = google_storage_bucket.bucket-gcp.self_link
}