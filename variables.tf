# GCP project that will host the resources

variable "project_id" {
    description = "GCP Project to deploy resource into"
    type        = string
}

# GCP region where resources will be deployed 

variable "region" {
    description = "GCP region to deploy resources into"
    type        = string
    default     = "us-central1"
}