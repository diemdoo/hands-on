# Create a GKE cluster
resource "google_container_cluster" "gke-01" {
  name     = "gke-01"
  location = "asia-southeast1-a"
  network  = google_compute_network.diemne.id
  subnetwork = google_compute_subnetwork.private_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1

  # Configure IP allocation for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = "diemne-secondary-range"
    services_secondary_range_name = "service-subnet"
  }

  # Master authorized networks (tùy chọn, giới hạn IP trong production)
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }
}

# Create a node pool
resource "google_container_node_pool" "node_pool_01" {
  name       = "node-pool-01"
  location   = "asia-southeast1-a"
  cluster    = google_container_cluster.gke-01.name
  node_count = 2

  node_config {
    preemptible     = false
    machine_type    = "e2-micro"
    service_account = "default"

    disk_size_gb = 10
    disk_type    = "pd-standard"


    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}

# Firewall rule to allow traffic within GKE
resource "google_compute_firewall" "gke_firewall" {
  name    = "gke-firewall"
  network = google_compute_network.diemne.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]  # Nên giới hạn trong production
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]  # Nên giới hạn trong production
  }

  source_ranges = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
  target_tags   = ["gke-node"]
}