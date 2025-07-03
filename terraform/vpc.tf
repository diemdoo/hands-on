# create VPC
resource "google_compute_network" "diemne" {
  name                    = "diemne"
  auto_create_subnetworks = false 
  description             = "my VPC network"
  routing_mode            = "REGIONAL"
}

# create Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "diemne-public-subnet"
  ip_cidr_range = "10.0.16.0/24" 
  region        = "asia-southeast1"
  network       = google_compute_network.diemne.id
  description   = "Public subnet for resource to access the internet"
}

# create Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  name          = "diemne-private-subnet"
  ip_cidr_range = "10.1.0.0/20" 
  region        = "asia-southeast1"
  network       = google_compute_network.diemne.id
  description   = "Private subnet for internal resources"
  private_ip_google_access = true # Enable private Google access for the subnet

  secondary_ip_range {
    range_name    = "diemne-secondary-range"
    ip_cidr_range = "10.1.16.0/20" # Secondary range for GKE pods
  }
  secondary_ip_range {
    range_name    = "service-subnet"
    ip_cidr_range = "10.3.0.0/16"  # Dải IP mới cho service, tránh xung đột
  }
}

# Create DB Subnet
resource "google_compute_subnetwork" "db_subnet" {
  name          = "diemne-db-subnet"
  ip_cidr_range = "10.2.0.0/20"  # Dải IP không trùng với các subnet khác
  region        = "asia-southeast1"
  network       = google_compute_network.diemne.id
  description   = "Private subnet for Cloud SQL instances"
  private_ip_google_access = true  # Bật private Google access
}

# Create Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = "diemne-router"
  region  = "asia-southeast1"
  network = google_compute_network.diemne.id
}

# Create Cloud NAT to private subnet access the internet
resource "google_compute_router_nat" "nat" {
  name                               = "diemne-nat"
  router                             = google_compute_router.router.name
  region                             = "asia-southeast1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}