resource "google_service_account" "default" {
  account_id   = "demo-gce-sa"
  display_name = "Service Account for Demo"
}

resource "google_compute_instance" "default" {
  name         = "demo-terraform-instance"
  machine_type = "e2-medium"
  zone         = "asia-northeast1-b"

  tags = ["http-serve", "http-serve"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  } 


  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "apt-get update -y && apt-get install - y nginx"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}