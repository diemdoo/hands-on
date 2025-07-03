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
resource "google_container_node_pool" "node_pool_02" {
  name       = "node-pool-02"
  location   = "asia-southeast1-a"
  cluster    = google_container_cluster.gke-01.name
  
  autoscaling {
    min_node_count = 2  # Số node tối thiểu
    max_node_count = 5  # Số node tối đa
  }

  node_config {
    spot = true # Sử dụng spot instance để tiết kiệm chi phí
    machine_type    = "custom-2-8192"
    service_account = "default"

    disk_size_gb = 15
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

