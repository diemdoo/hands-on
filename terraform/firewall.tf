# Tạo firewall rule để cho phép SSH vào bastion host
resource "google_compute_firewall" "allow_ssh_bastion" {
  name    = "allow-ssh-bastion"
  network = google_compute_network.diemne.id

  allow {
    protocol = "all"
    #ports    = ["22"]
  }

  source_ranges = ["116.108.4.68"] 
  target_tags   = ["bastion"]
  description   = "Allow SSH into bastion host"
}

# Tạo firewall rule để cho phép OpenVPN (port 1194/UDP)
resource "google_compute_firewall" "allow_openvpn" {
  name    = "allow-openvpn"
  network = google_compute_network.diemne.id

  allow {
    protocol = "udp"
    ports    = ["1194"]
  }

  source_ranges = ["0.0.0.0/0"] # Hạn chế dải IP nếu cần (ví dụ: ["YOUR_IP/32"])
  target_tags   = ["openvpn"]
  description   = "Allow access OpenVPN server"
}

# Tạo firewall rule để cho phép giao tiếp từ VPN clients đến private subnet
resource "google_compute_firewall" "allow_vpn_to_private" {
  name    = "allow-vpn-to-private"
  network = google_compute_network.diemne.id

  allow {
    protocol = "all" # Có thể giới hạn TCP/22 cho SSH
  }

  source_ranges = ["10.8.0.0/24"] # Dải IP của VPN clients
  # target_tags   = ["private"]
  description   = "Allow VPN clients access private subnet"
}

# Tạo firewall rule để cho phép giao tiếp từ public đến private subnet
resource "google_compute_firewall" "allow_public_to_private" {
  name    = "allow-public-to-private"
  network = google_compute_network.diemne.id

  allow {
    protocol = "TCP"
    ports    = ["22"] # Có thể giới hạn TCP/22 cho SSH
  }

  source_ranges = ["10.0.16.0/24"] # Dải IP của VPN clients
  # target_tags   = ["private"]
  description   = "Allow public subnet access private subnet"
}

# Tạo firewall rule để cho phép giao tiếp từ public đến private subnet
resource "google_compute_firewall" "allow_tailscale_to_console" {
  name    = "allow-tailscale-to-console"
  network = google_compute_network.diemne.id

  allow {
    protocol = "udp"
    ports    = ["41641"] 
  }

  source_ranges = ["0.0.0.0/0"] # Dải IP của VPN clients
  # target_tags   = ["private"]
  description   = "Allow tailscale access to console"
}