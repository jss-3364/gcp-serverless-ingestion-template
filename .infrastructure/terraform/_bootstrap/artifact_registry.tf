# Artifact registry
# Contains unnest docker image for python
resource "google_artifact_registry_repository" "python_artifacts" {
  repository_id = local.artifact_registry_repository
  location      = local.region
  description   = "This repository is created and used by Cloud Run for storing python docker images."
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = 5
    }
  }

  depends_on = [google_project_service.enable_apis]
}
