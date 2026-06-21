terraform {
  required_version = ">= 1.12.0"

  required_providers {
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.21"
    }
    unifi = {
      source  = "BadgerOps/unifi"
      version = "~> 0.2"
    }
  }
}
