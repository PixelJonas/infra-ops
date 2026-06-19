import {
  to = cloudflare_zero_trust_tunnel_cloudflared.synology
  id = "${local.cloudflare_account_id}/${local.tunnel_synology_id}"
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "synology" {
  account_id    = local.cloudflare_account_id
  name          = "Synology"
  tunnel_secret = local.tunnel_synology_secret
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "synology" {
  account_id = local.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.synology.id

  config = {
    ingress = [
      {
        hostname = "statesman.${local.zone_name_famjanz}"
        service  = local.tunnel_svc_synology
      },
      {
        hostname = "hass.${local.zone_name}"
        service  = local.tunnel_svc_hass
      },
      {
        service = "http_status:404"
      },
    ]
  }
}

import {
  to = cloudflare_zero_trust_tunnel_cloudflared.k8s
  id = "${local.cloudflare_account_id}/${local.tunnel_k8s_id}"
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "k8s" {
  account_id    = local.cloudflare_account_id
  name          = "home-k8s"
  tunnel_secret = local.tunnel_k8s_secret
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "k8s" {
  account_id = local.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.k8s.id

  config = {
    ingress = [
      {
        hostname = "tv.${local.zone_name}"
        service  = local.tunnel_svc_tv
      },
      {
        hostname = "finance.${local.zone_name}"
        service  = local.tunnel_svc_finance
      },
      {
        hostname = "paperless.${local.zone_name}"
        service  = local.tunnel_svc_paperless
      },
      {
        hostname = "vault.${local.zone_name}"
        path     = "/admin"
        service  = "http_status:404"
      },
      {
        hostname = "vault.${local.zone_name}"
        service  = local.tunnel_svc_vault
      },
      {
        hostname = "request.${local.zone_name}"
        service  = local.tunnel_svc_request
      },
      {
        service = "http_status:404"
      },
    ]
  }
}
