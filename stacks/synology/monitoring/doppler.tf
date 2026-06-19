data "doppler_secrets" "this" {}

locals {
  synology_api_url          = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user             = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password         = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD
  unpoller_unifi_pass       = data.doppler_secrets.this.map.UNPOLLER_UNIFI_PASS
  hass_prometheus_token     = data.doppler_secrets.this.map.HASS_PROMETHEUS_TOKEN
  monitoring_share_path     = nonsensitive(data.doppler_secrets.this.map.INFRA_MONITORING_SHARE_PATH)
  monitoring_host_path      = nonsensitive(data.doppler_secrets.this.map.INFRA_MONITORING_HOST_PATH)
  unifi_host                = data.doppler_secrets.this.map.INFRA_UNIFI_HOST
  unpoller_username         = nonsensitive(data.doppler_secrets.this.map.INFRA_UNPOLLER_USERNAME)
  victoriametrics_write_url = nonsensitive(data.doppler_secrets.this.map.INFRA_VICTORIAMETRICS_WRITE_URL)
  scrape_targets            = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_SCRAPE_TARGETS))
}
