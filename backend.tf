terraform {
  backend "gcs" {
    bucket  = "your-tf-state-bucket"   # Replace with your actual bucket name
    prefix  = "idp-infra/state"        # Folder path inside the bucket
  }
}