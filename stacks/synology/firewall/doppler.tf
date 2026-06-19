data "doppler_secrets" "this" {}

locals {
  synology_api_url  = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user     = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD
}
