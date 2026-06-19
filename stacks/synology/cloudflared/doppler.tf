data "doppler_secrets" "this" {}

locals {
  synology_api_url        = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user           = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password       = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD
  cloudflare_tunnel_token = data.doppler_secrets.this.map.CLOUDFLARE_TUNNEL_TOKEN
  cloudflared_share_path  = data.doppler_secrets.this.map.INFRA_CLOUDFLARED_SHARE_PATH
}
