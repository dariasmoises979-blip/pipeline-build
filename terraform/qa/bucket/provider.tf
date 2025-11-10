#-----------------------------
# Configure the gcp 
#-----------------------------

provider "google" {
  credentials       = file(var.gcp_credentials_file) # Path to the GCP credentials JSON file
  project           = var.gcp_project_id              # GCP Project ID
  region            = local.gcp_region                # GCP Region
  default_labels    = {
    environment     = "qa"                            # Default label for the environment
  }
}