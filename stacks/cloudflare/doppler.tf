data "doppler_secrets" "this" {}

locals {
  cloudflare_api_token  = data.doppler_secrets.this.map.CF_API_TOKEN
  cloudflare_account_id = nonsensitive(data.doppler_secrets.this.map.CF_ACCOUNT_ID)
  cloudflare_zone_id    = nonsensitive(data.doppler_secrets.this.map.CF_ZONE_ID)

  tunnel_synology_id     = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SYNOLOGY_ID)
  tunnel_synology_secret = data.doppler_secrets.this.map.CF_TUNNEL_SYNOLOGY_SECRET
  tunnel_k8s_id          = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_K8S_ID)
  tunnel_k8s_secret      = data.doppler_secrets.this.map.CF_TUNNEL_K8S_SECRET

  zone_name         = nonsensitive(data.doppler_secrets.this.map.CF_ZONE_NAME)
  zone_name_famjanz = nonsensitive(data.doppler_secrets.this.map.CF_ZONE_NAME_FAMJANZ)

  mail_dkim_domain = nonsensitive(data.doppler_secrets.this.map.CF_MAIL_DKIM_DOMAIN)
  mail_mx_primary  = nonsensitive(data.doppler_secrets.this.map.CF_MAIL_MX_PRIMARY)
  mail_mx_secondary = nonsensitive(data.doppler_secrets.this.map.CF_MAIL_MX_SECONDARY)
  mail_spf         = nonsensitive(data.doppler_secrets.this.map.CF_MAIL_SPF)

  tunnel_svc_synology = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_SYNOLOGY)
  tunnel_svc_hass     = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_HASS)
  tunnel_svc_tv       = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_TV)
  tunnel_svc_finance  = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_FINANCE)
  tunnel_svc_paperless = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_PAPERLESS)
  tunnel_svc_vault    = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_VAULT)
  tunnel_svc_request  = nonsensitive(data.doppler_secrets.this.map.CF_TUNNEL_SVC_REQUEST)
}
