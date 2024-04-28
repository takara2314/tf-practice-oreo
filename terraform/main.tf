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

resource "google_cloud_run_v2_service" "default" {
  name     = "oreo-service"
  location = "asia-northeast1"

  template {
    containers {
      image = format(
        "%s.docker.pkg.dev/%s/%s:latest",
        local.region,
        local.project_id,
        "oreo-service"
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
