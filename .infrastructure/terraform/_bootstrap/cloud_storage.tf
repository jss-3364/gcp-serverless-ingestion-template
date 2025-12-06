# Cloud Storage Bucket
resource "google_storage_bucket" "tf_state_bucket" {
  name          = local.tf_state_bucket
  location      = local.region
  force_destroy = true

  depends_on = [google_project_service.enable_apis]
}
