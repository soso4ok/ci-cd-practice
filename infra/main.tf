provider "google" {
  credentials = file("~/terraform-key.json")
  project = var.project_id
  region  = var.region
}


# VPC
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# SUBNET
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  

}

# VMs
resource "google_compute_instance" "vm_instance" {
  count        = 2
  name         = "vm-instance-${count.index + 1}"
  machine_type = "e2-micro"  
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "family/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}  
  }

    metadata_startup_script = <<SCRIPT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io
    systemctl start docker
    gcloud auth configure-docker --quiet
  SCRIPT
}