# create VM Bastion Host in public subnet
resource "google_compute_instance" "bastion" {
  name         = "diemne-bastion"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {} # Ephemeral IP address
  }

  tags = ["bastion", "openvpn"] # Áp dụng tag để firewall rule hoạt động


  metadata = {
    ssh-keys = "diemxinh:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9sUIVHbCW03UmvOjUj9J8TT8UyYVXmgieg1xKxOKg1 diemxinh" # Thay bằng username và SSH public key
  }

  labels = {
    environment = "dev"
    role        = "bastion"
  }
}