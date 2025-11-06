#-----------------------------------------
# Terraform Variables for QA S3 Bucket
#-----------------------------------------

locals {
    gcp_project_id = "my-gcp-project-id"  # Replace with your actual GCP project ID
    gcp_region     = "us-central1"        # Replace with your desired GCP region
    
    
    gcp_tags    = {

        Environment = "QA"
        Team        = "DevOps"
        Project     = "MyProject"
    }          # Comma-separated tags for the environment

}