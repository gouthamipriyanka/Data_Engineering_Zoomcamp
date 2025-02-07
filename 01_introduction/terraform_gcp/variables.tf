variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default     = "asia-south1"
  type        = string
}

variable "storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default     = "STANDARD"
}

variable "storage_bucket" {
  description = "Storage bucket"
  default     = "amplified-lamp-449107-s0-terra--bucket"
}

variable "BQ_DATASET" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type        = string
  default     = "demo_dataset"
}

# # Transfer service
# variable "access_key_id" {
#   description = "AWS access key"
#   type = string
# }

# variable "aws_secret_key" {
#   description = "AWS secret key"
#   type = string
# }