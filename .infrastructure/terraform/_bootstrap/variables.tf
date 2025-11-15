variable "location" {
  type        = string
  description = "The region to be used in the project"
  nullable    = true
  default     = "europe-west1"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
  nullable    = false
}

variable "tf_state_bucket" {
  type        = string
  description = "The bucket name to be used for the Terraform state"
  nullable    = false
}
