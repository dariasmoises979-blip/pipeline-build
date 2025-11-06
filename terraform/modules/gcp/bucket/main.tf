#-------------------------------------------------
# GCP Bucket Module
#-------------------------------------------------

# Resource to create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket-gcp" {
    name          = var.bucket_name # Name of the bucket, provided as a variable
    location      = var.location    # Location/region of the bucket, provided as a variable
    force_destroy = var.force_destroy # Whether to force destroy the bucket, provided as a variable
    # acl = "private" # Uncomment to set ACL to private
}

# Resource to define Access Control List (ACL) for the bucket
resource "google_storage_bucket_acl" "bucket_acl" {
    bucket = google_storage_bucket.bucket-gcp.name # Reference to the bucket created above
    role_entity = [
        "OWNER:project-owners-${var.project_id}", # Owner role for project owners
        "READER:allUsers" # Reader role for all users
    ]
}

# Resource to define IAM bindings for the bucket
resource "google_storage_bucket_iam_binding" "bucket_iam_binding" {
    bucket = google_storage_bucket.bucket-gcp.name # Reference to the bucket created above

    role = "roles/storage.objectViewer" # Role assigned to the members

    members = [
        "user:${var.user_email}", # Specific user email provided as a variable
        "serviceAccount:example-service-account@${var.project_id}.iam.gserviceaccount.com" # Service account with access
    ]
}

