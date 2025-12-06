provider "google" {
  project = local.project_id
  region  = local.region

  # default labels for all resources
  default_labels = {
    creator = "jss_3364"
  }
}

# GCP services to enable for the project
resource "google_project_service" "enable_apis" {
  for_each           = local.gcp_api_services
  service            = each.value
  disable_on_destroy = false
}
