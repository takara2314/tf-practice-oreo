terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
}

provider "google" {
  project = "tf-practice-oreo"
  region  = "asia-northeast1"
}

resource "google_cloud_run_v2_service" "default" {
  name     = "oreo-service"
  location = "asia-northeast1"

  template {
    containers {
      image = "gcr.io/cloudrun/hello"
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
