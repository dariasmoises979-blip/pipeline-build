#-------------------------------------------------
# GCP Bucket Module
#-------------------------------------------------

# Resource to create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket-gcp" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.location
  force_destroy = var.force_destroy

  # Enable uniform bucket-level access (recommended)
  uniform_bucket_level_access = true

  # Enable versioning
  versioning {
    enabled = var.enable_versioning
  }

  # Optional: Lifecycle rules
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type = lifecycle_rule.value.action
      }
      condition {
        age = lifecycle_rule.value.age
      }
    }
  }

  # Optional: Add labels for better organization
  labels = var.labels
}

# Resource to define IAM bindings for the bucket
resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
  bucket = google_storage_bucket.bucket-gcp.name
  role   = "roles/storage.objectViewer"

  members = [
    "user:${var.user_email}"
  ]
}

# Optional: Add writer role for the user
resource "google_storage_bucket_iam_binding" "bucket_iam_writer" {
  count  = var.grant_write_access ? 1 : 0
  bucket = google_storage_bucket.bucket-gcp.name
  role   = "roles/storage.objectAdmin"

  members = [
    "user:${var.user_email}"
  ]
}