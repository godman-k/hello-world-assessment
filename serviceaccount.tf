# Service Account for Cloud Function
resource "google_service_account" "cloudfunction_sa" {
  account_id   = "cloudfunction-sa"
  display_name = "Cloud Function Service Account"
}

# IAM Binding for Cloud Function Service Account to access Cloud SQL
resource "google_project_iam_member" "cloudfunction_sa_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudfunction_sa.email}"
}

resource "google_project_iam_member" "cloudfunction_sa_sql_instance_user" {
  project = var.project_id
  role    = "roles/cloudsql.instanceUser"
  member  = "serviceAccount:${google_service_account.cloudfunction_sa.email}"
}
