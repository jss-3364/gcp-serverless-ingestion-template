provider "google" {
  project = local.project_id
  region  = local.region

  # default labels for all resources
  default_labels = {
    creator = "jss_3364"
  }
}