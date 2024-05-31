# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "id-me-vpc-net"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "id-me-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# VPC Connector
resource "google_vpc_access_connector" "vpc_connector" {
  name          = "vpc-connector"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.8.0.0/28"
  region        = var.region
}
