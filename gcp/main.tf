provider "google" {
  project     = "cloud-resume-challenge-485617"
  region      = "us-east1"
}

variable "root_domain" { type = string } # e.g "yemanenigusseresume.org"

locals {
  apex = var.root_domain
  www  = "www.${var.root_domain}"
}

resource "google_storage_bucket" "site_www" {
  name          = local.www
  location      = "us-east1"
  force_destroy = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket" "site_apex_redirect" {
  name          = local.apex
  location      = "us-east1"
  force_destroy = true
  uniform_bucket_level_access = true

  # Redirect apex -> www over HTTPS 
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
    # NOTE: GCS "RedirectAllRequestsTo" is not a field here like S3. 
    # for GCS, upload a minimal index.html with a meta refresh OR
    # use CloudFlare Page Rule/Worker to 301 redirect apex -> www. 
  }
#   cors {
#     origin          = ["http://image-store.com"]
#     method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
#     response_header = ["*"]
#     max_age_seconds = 3600
#   }
#   cors {
#     origin            = ["http://image-store.com"]
#     method            = ["GET", "HEAD", "PUT", "POST", "DELETE"]
#     response_header   = ["*"]
#     max_age_seconds   = 0
#   }
}

# Public read on the site bucket 
resource "google_storage_bucket_iam_member" "www_public" {
  bucket = google_storage_bucket.site_www.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
  
}

# https://yemanenigusseresume.org.storage.googleapis.com/index.html