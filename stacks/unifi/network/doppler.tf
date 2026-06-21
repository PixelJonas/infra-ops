data "doppler_secrets" "this" {}

locals {
  unifi_host    = data.doppler_secrets.this.map.INFRA_UNIFI_HOST
  unifi_api_key = data.doppler_secrets.this.map.INFRA_UNIFI_API_KEY
}
