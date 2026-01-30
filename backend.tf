terraform {
  backend "gcs" {
    bucket  = "idp-tf-state-bucket"   # Replace with your actual bucket name
    prefix  = "idp-infra/state"        # Folder path inside the bucket
  }
}