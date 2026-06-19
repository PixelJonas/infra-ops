terraform {
  required_version = ">= 1.12.0"

  required_providers {
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.21"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.20"
    }
  }
}
