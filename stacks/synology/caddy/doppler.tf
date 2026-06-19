data "doppler_secrets" "this" {}

locals {
  synology_api_url     = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user        = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password    = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD
  cloudflare_api_token = data.doppler_secrets.this.map.CLOUDFLARE_API_KEY
  acme_email           = data.doppler_secrets.this.map.INFRA_ACME_EMAIL
  caddy_share_path     = nonsensitive(data.doppler_secrets.this.map.INFRA_CADDY_SHARE_PATH)
  caddy_host_path      = nonsensitive(data.doppler_secrets.this.map.INFRA_CADDY_HOST_PATH)
  synology_ssh_host    = data.doppler_secrets.this.map.INFRA_SYNOLOGY_SSH_HOST
  synology_ssh_user    = data.doppler_secrets.this.map.INFRA_SYNOLOGY_SSH_USER
  proxy_hosts          = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_PROXY_HOSTS))
}
