locals {
  project_id = "tf-practice-oreo"
  region     = "asia-northeast1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
  backend "gcs" {
    bucket = "tf-practice-oreo-terraform-bucket"
  }
}

resource "google_storage_bucket" "terraform-state-store" {
  name          = "tf-practice-oreo-terraform-bucket"
  location      = local.region
  storage_class = "REGIONAL"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 5
    }
  }
}

resource "google_artifact_registry_repository" "oreo-service" {
  location      = local.region
  repository_id = "oreo-service"
  description   = "main docker repository"
  format        = "DOCKER"
}

resource "google_cloud_run_v2_service" "oreo-service" {
  name     = google_artifact_registry_repository.oreo-service.repository_id
  location = local.region

  template {
    containers {
      image = format(
        "%s-docker.pkg.dev/%s/%s/%s:%s",
        local.region,
        local.project_id,
        google_artifact_registry_repository.oreo-service.repository_id,
        "backend",
        var.oreo_service_backend_image_tag
      )
      ports {
        container_port = 8080
      }
    }
  }
}


resource "google_cloud_run_domain_mapping" "oreo-service" {
  name     = "oreo.2314.world"
  location = google_cloud_run_v2_service.oreo-service.location
  metadata {
    namespace = local.project_id
  }
  spec {
    route_name = google_cloud_run_v2_service.oreo-service.name
  }
}

resource "google_cloud_run_service_iam_member" "oreo-service" {
  service  = google_cloud_run_v2_service.oreo-service.name
  location = google_cloud_run_v2_service.oreo-service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
