resource "google_storage_bucket" "diemne2" {
  name          = "diemne2"
  location      = "ASIA"
  storage_class = "STANDARD"

  labels = {
    environment = "dev"
  }
}