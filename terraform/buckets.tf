resource "google_storage_bucket" "tfstate" {
  name          = "diemne-tfstate"
  location      = "ASIA"
  storage_class = "STANDARD"

  labels = {
    environment = "dev"
  }
}