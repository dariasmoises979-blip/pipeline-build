#-----------------------------
# Configure the gcp 
#-----------------------------

provider "google" {
  credentials = file(var.gcp_credentials_file) # Path to the GCP credentials file
  project     = var.gcp_project_id              # GCP Project ID
  region      = var.gcp_region                  # GCP Region
  default_labels = {
    environment = "qa"                           # Default label for the environment
  }
}