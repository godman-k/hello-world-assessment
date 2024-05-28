# Cloud Storage Bucket for function source code
resource "google_storage_bucket" "function_source_bucket" {
  name     = "${var.project_id}-fun-source"
  location = var.region
}

# Cloud Storage Bucket Object for function source code
resource "google_storage_bucket_object" "function_source_archive" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = "app/function-source.zip"
}
