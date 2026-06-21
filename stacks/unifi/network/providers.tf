provider "doppler" {}

provider "unifi" {
  api_url        = local.unifi_api_url
  api_key        = local.unifi_api_key
  allow_insecure = true
}
