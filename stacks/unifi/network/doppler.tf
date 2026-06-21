data "doppler_secrets" "this" {}

locals {
  unifi_api_url = data.doppler_secrets.this.map.INFRA_UNIFI_API_URL
  unifi_api_key = data.doppler_secrets.this.map.INFRA_UNIFI_API_KEY
}
