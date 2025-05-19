# Bật OS Login cho project bằng cách thêm metadata
resource "google_compute_project_metadata" "os_login" {
  metadata = {
    enable-oslogin = "TRUE"
    # (Tùy chọn) Bật 2-Step Verification cho OS Login
    enable-oslogin-2fa = "TRUE"
  }
}

# Gán IAM role để user có thể truy cập VM qua OS Login
resource "google_project_iam_member" "os_login_user" {
  project = "diem-do"  # Thay bằng project ID của bạn
  role    = "roles/compute.osAdminLogin"  # Quyền admin (có sudo), hoặc dùng roles/compute.osLogin nếu chỉ cần quyền user
  member  = "user:ngocdiemdo04@gmail.com"  # Thay bằng email của user
}

# Gán IAM role cho user duyhenry250897@gmail.com
resource "google_project_iam_member" "os_login_user_duyhenry" {
  project = "diem-do"
  role    = "roles/compute.osAdminLogin"
  member  = "user:duyhenry250897@gmail.com"
}

# # Thêm SSH public key vào OS Login profile của user
# resource "google_os_login_ssh_public_key" "user_key" {
#   project    = "diem-do"  # Thay bằng project ID của bạn
#   user       = "ngocdiemdo04@gmail.com"  # Thay bằng email của user
#   key        = file("~/.ssh/id_ed25519.pub")  # Đường dẫn đến file public key
 
# }
