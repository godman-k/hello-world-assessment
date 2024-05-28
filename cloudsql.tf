# Cloud SQL Database Instance
resource "google_sql_database_instance" "db_instance" {
  name             = "hello-world-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }

}

# Cloud SQL Database
resource "google_sql_database" "db" {
  name     = "hello_world"
  instance = google_sql_database_instance.db_instance.name
}

# Cloud SQL User
resource "google_sql_user" "users" {
  name     = var.db_user
  password = var.db_password
  instance = google_sql_database_instance.db_instance.name
}
