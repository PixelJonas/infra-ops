terraform {
  required_version = ">= 1.12.0"

  required_providers {
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.21"
    }
    synology = {
      source  = "florianehmke/synology-dsm"
      version = "0.7.7"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}
