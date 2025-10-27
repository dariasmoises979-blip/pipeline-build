terraform {
  backend "gcs" {
    bucket  = "my-terraform-state-bucket"
    prefix  = "project_name/terraform/state"
    project = "my-gcp-project"
  }
}
