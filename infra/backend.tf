terraform {
  backend "gcs" {
    bucket = "terra-ops-test"
    prefix = "terrafrom/state"
  }
}