# Kubernetes and Helm provider configuration - connects Terraform to the GKE cluster to deploy resources

# Get GCP credentials to generate access token for authentication
data "google_client_config" "default" {}

# Fetches GKE cluster details (endpoint and certificate) created in main.tf
data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = var.region
}


# Kubernetes provider - allows Terraform to manage resources inside the cluster
provider "kubernetes" {
  host  = data.google_container_cluster.primary.endpoint
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  )
}

# Helm provider - allows Terraform to deploy applications (ArgoCD, Prometheus, Grafana) using Helm Charts
provider "helm" {
  kubernetes = {
    host  = data.google_container_cluster.primary.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    )
  }
}