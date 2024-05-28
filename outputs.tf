output "network_id" {
  description = "The ID of the created VPC network"
  value       = google_compute_network.vpc_network.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "vpc_connector_id" {
  description = "The ID of the created VPC Connector"
  value       = google_vpc_access_connector.vpc_connector.id
}

output "db_instance_connection_name" {
  description = "The connection name of the Cloud SQL Database Instance"
  value       = google_sql_database_instance.db_instance.connection_name
}

output "function_url" {
  description = "The URL of the deployed Cloud Function"
  value       = google_cloudfunctions_function.function.https_trigger_url
}
