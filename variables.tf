variable "project_id" {
    description = "GCP Project to deploy resource into"
    type        = string
}

variable "region" {
    description = "GCP region to deploy resources into"
    type        = string
    default     = "us-central1"
}