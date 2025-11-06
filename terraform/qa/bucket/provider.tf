#-----------------------------
# Configure the gcp 
#-----------------------------

provider "google" {
  credentials       = file(local.gcp_project_id) # Path to the GCP credentials file
  project           = local.gcp_project_id              # GCP Project ID
  region            = local.gcp_region                  # GCP Region
  default_labels    = {
    environment     = "qa"  
    tags            = local.gcp_tags                         # Default label for the environment
  }
}