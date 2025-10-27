# Networking (VPC + Subnet)

resource "google_compute_network" "vpc_network" {
    name                    = "idp-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
    name          = "idp-subnet"
    ip_cidr_range = "10.0.0.0/16"
    region        = var.region
    network       = google_compute_network.vpc_network.id
}

# GKE Cluster

resource "google_container_cluster" "primary" {
    name     = "idp-gke-cluster"
    location = var.region

    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name

    remove_default_node_pool = true
    initial_node_count       = 1
}

# GKE Node Pool

resource "google_container_node_pool" "primary_nodes" {
    name     = "idp-node-pool"
    cluster  = google_container_cluster.primary.name
    location = var.region

    node_count = 3

    node_config {
        machine_type = "e2-medium"
        oauth_scopes = [
                 "https://www.googleapis.com/auth/cloud-platform",
        ]      
    }
}

# Artifact Registry

resource "google_artifact_registry_repository" "idp_repo" {
  provider      = google
  location      = var.region
  repository_id = "idp-artifacts"
  description   = "Artifact Registry for IDP"
  format        = "DOCKER"
}

# Secret Manager

resource "google_secret_manager_secret" "idp_secret" {
  secret_id = "idp-secret"
  replication {
    automatic = true
  }
}

# IAM service account and roles

resource "google_service_account" "idp_sa" {
  account_id   = "idp-service-account"
  display_name = "IDP Service Account"
}

resource "google_project_iam_member" "idp_sa_roles" {
  for_each = toset([
    "roles/container.admin",
    "roles/artifactregistry.writer",
    "roles/secretmanager.admin"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.idp_sa.email}"
}