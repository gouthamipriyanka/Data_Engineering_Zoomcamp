terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  # credentials = "./keys/my_creds.json"
  project = "amplified-lamp-449107-s0"
  region  = var.region
}

resource "google_storage_bucket" "demo-bucket" {
  name          = var.storage_bucket
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.BQ_DATASET
  location = var.region
}

