# Cloud Storage Bucket
resource "google_storage_bucket" "tf_state_bucket" {
  name          = local.tf_state_bucket
  location      = local.region
  force_destroy = true
}

# GCP services to enable for the project
resource "google_project_service" "enable_apis" {
  for_each           = local.gcp_api_services
  service            = each.value
  disable_on_destroy = false
}