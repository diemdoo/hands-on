resource "google_compute_instance" "private_vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.name
    # Không gán public IP để VM chỉ truy cập được qua VPN
  }

  tags = ["vpn-access"]

}
