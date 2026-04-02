# GCP provider configuration - specifies Google Cloud as the provider and sets the project and region for deployments 

provider "google" {
    project = var.project_id
    region  = var.region
}