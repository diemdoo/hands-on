# Tạo global address cho Private Service Access
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.diemne.id
}

# Tạo VPC peering cho Cloud SQL
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.diemne.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# Tạo Cloud SQL instance
resource "google_sql_database_instance" "postgresql_01" {
  name             = "postgresql-01"
  database_version = "POSTGRES_15"
  region           = "asia-southeast1"
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.diemne.id
    }
  }
}

# Tạo database
resource "google_sql_database" "todo" {
  name     = "todo"
  instance = google_sql_database_instance.postgresql_01.name
}

# # Tạo user
# resource "google_sql_user" "app_user" {
#   name     = "todo-app-user"
#   instance = google_sql_database_instance.postgresql_01.name
#   password = "secure-password-123"  # Lưu trong Secret Manager trong production
# }