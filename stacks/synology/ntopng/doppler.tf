data "doppler_secrets" "this" {}

locals {
  synology_api_url      = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user         = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password     = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD
  ntopng_share_path     = data.doppler_secrets.this.map.INFRA_NTOPNG_SHARE_PATH
  ntopng_data_host_path = data.doppler_secrets.this.map.INFRA_NTOPNG_DATA_HOST_PATH
  ntopng_port           = data.doppler_secrets.this.map.INFRA_NTOPNG_PORT
  ntopng_interfaces     = split(",", data.doppler_secrets.this.map.INFRA_NTOPNG_INTERFACES)
  timezone              = data.doppler_secrets.this.map.INFRA_TIMEZONE
}
