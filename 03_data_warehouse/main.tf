terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
    credentials = "./keys/my_creds.json"
    project = var.project_id
    region  = var.region
}
resource "google_storage_bucket" "static" {
 name          = "datatalks_warehouse_bucket03"
 location      = var.region
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}

# Upload a text file as an object
# to the storage bucket

# Define the folder containing your files
locals {
  folder_path = "./yellow_tripdata_2024"  # Path to the folder containing your files
  files       = [for f in fileset(local.folder_path, "**/*") : "${local.folder_path}/${f}"]
}

resource "google_storage_bucket_object" "files" {
  for_each     = toset(local.files)  # Iterate over all files in the folder
  name         = basename(each.value)  # Get the file name (without path)
  source       = each.value  # Local path to the file
  content_type = "application/octet-stream"  # MIME type (change if necessary)
  bucket       = google_storage_bucket.static.id  # Reference to the existing bucket
}

resource "google_bigquery_dataset" "ny_taxi" {
  dataset_id = var.BQ_DATASET
  location = var.region
}
