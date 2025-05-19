# This file contains the Terraform configuration for deploying a Google Cloud Platform (GCP) infrastructure.
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "diem-do"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-a"
  
}
