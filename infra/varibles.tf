variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
    default     = "europe-west6"     
}

variable "zone" {
  description = "The GCP region"
  type        = string
    default     = "europe-west6-a"     
}

