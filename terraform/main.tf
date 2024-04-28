terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
}

locals {
  project_id = "tf-practice-oreo"
  region     = "asia-northeast1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

resource "google_artifact_registry_repository" "default" {
  location      = local.region
  repository_id = "oreo-service"
  description   = "main docker repository"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "default" {
  name     = google_artifact_registry_repository.default.repository_id
  location = local.region

  template {
    containers {
      image = format(
        "%s-docker.pkg.dev/%s/%s/%s:latest",
        local.region,
        local.project_id,
        google_artifact_registry_repository.default.repository_id,
        "backend"
      )
      ports {
        container_port = 8080
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "default" {
  service  = google_cloud_run_v2_service.default.name
  location = google_cloud_run_v2_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
