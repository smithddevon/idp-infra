output "cluster_name" {
    value = google_container_cluster.primary.name
}

output "kubeconfig_command" {
    value = "gcloud container cluster get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}

output "service_account_email" {
  value = google_service_account.idp_sa.email
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.idp_images.repository_id
}