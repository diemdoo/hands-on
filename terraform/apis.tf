# Define local variable with list of services
locals {
  apis_services = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "storage.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

# Enable all APIs using for_each
resource "google_project_service" "apis_services" {
  for_each = toset(local.apis_services)

  project = "diem-do"
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}
