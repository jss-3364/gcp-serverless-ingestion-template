locals {
  # from makefile
  tf_state_bucket = var.tf_state_bucket
  project_id = var.project_id
  region     = var.location

  # GCP services to enable for the project
  # Doc : https://developers.google.com/apis-explorer
  gcp_api_services = toset([
    "compute.googleapis.com",
    "storage.googleapis.com"
  ])
}