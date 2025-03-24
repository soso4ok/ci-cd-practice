variable "project_id" {GCP_PROJECT_ID}
variable "region" {}


provider "google" {
  project     = "$GCP_PROJECT_ID"
  region      = "$GCP_REGION"
}

data "google_billing_account" "account" {
  billing_account = "$BILLING_ACCOUNT"
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name = "Example Billing Budget"
  amount {
    specified_amount {
      currency_code = "USD"
      units = "100"
    }
  }
  threshold_rules {
      threshold_percent =  0.5
  }
}