variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default     = "asia-south1"
  type        = string
}

variable "storage_bucket" {
  description = "Storage bucket"
  default     = "<bucket-name"
}

variable "project_id" {
  description = "Project ID"
  default     = "<project_id>"
}

variable "BQ_DATASET" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type        = string
  default     = "ny_taxi"
}