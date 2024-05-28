# Cloud Function
resource "google_cloudfunctions_function" "function" {
  name                  = "hello-world"
  description           = "A Cloud Function to connect to Cloud SQL"
  runtime               = "nodejs18"
  entry_point           = "connectToCloudSQL"
  source_archive_bucket = google_storage_bucket.function_source_bucket.name
  source_archive_object = google_storage_bucket_object.function_source_archive.name
  trigger_http          = true
  available_memory_mb   = 128

  environment_variables = {
    DB_NAME     = google_sql_database.db.name
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_INSTANCE = google_sql_database_instance.db_instance.connection_name
  }

  vpc_connector    = google_vpc_access_connector.vpc_connector.name
  service_account_email = google_service_account.cloudfunction_sa.email
  ingress_settings = "ALLOW_ALL"
}

# Allow public access to the Cloud Function
resource "google_cloudfunctions_function_iam_member" "public_access" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
