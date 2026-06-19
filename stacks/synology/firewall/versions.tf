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
  }
}
