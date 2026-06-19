locals {
  tunnel_cname_records = {
    finance   = { record_id = "8f85fe00c0965a5d55535b9aea62449e", tunnel_id = local.tunnel_k8s_id }
    hass      = { record_id = "de96968ad2e380f8390e167221ff39cd", tunnel_id = local.tunnel_synology_id }
    paperless = { record_id = "0ec1d5ef8c4e1aa2a04e2848ab8860c6", tunnel_id = local.tunnel_k8s_id }
    request   = { record_id = "2e9d4325d32260092715f1376113fe22", tunnel_id = local.tunnel_k8s_id }
    tv        = { record_id = "7343af0488c5b956775ebf2c7c8739d0", tunnel_id = local.tunnel_k8s_id }
    vault     = { record_id = "810add5753592f49d7d52044177545b1", tunnel_id = local.tunnel_k8s_id }
  }
}

import {
  for_each = local.tunnel_cname_records
  to       = cloudflare_dns_record.tunnel[each.key]
  id       = "${local.cloudflare_zone_id}/${each.value.record_id}"
}

resource "cloudflare_dns_record" "tunnel" {
  for_each = local.tunnel_cname_records

  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = each.key
  content = "${each.value.tunnel_id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

# --- FastMail DKIM ---

import {
  to = cloudflare_dns_record.dkim_fm1
  id = "${local.cloudflare_zone_id}/dbab8020a3f449a38e92c2b9890a99bc"
}

resource "cloudflare_dns_record" "dkim_fm1" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "fm1._domainkey"
  content = "fm1.${local.zone_name}.${local.mail_dkim_domain}"
  proxied = false
  ttl     = 1
}

import {
  to = cloudflare_dns_record.dkim_fm2
  id = "${local.cloudflare_zone_id}/cb38e6705cfdd5f6d2bcb55022e87fc4"
}

resource "cloudflare_dns_record" "dkim_fm2" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "fm2._domainkey"
  content = "fm2.${local.zone_name}.${local.mail_dkim_domain}"
  proxied = false
  ttl     = 1
}

import {
  to = cloudflare_dns_record.dkim_fm3
  id = "${local.cloudflare_zone_id}/1a5738681df6b7621153f633cd1eda3e"
}

resource "cloudflare_dns_record" "dkim_fm3" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "fm3._domainkey"
  content = "fm3.${local.zone_name}.${local.mail_dkim_domain}"
  proxied = false
  ttl     = 1
}

# --- FastMail MX ---

import {
  to = cloudflare_dns_record.mx_apex_primary
  id = "${local.cloudflare_zone_id}/cc942547115f7085c197c72d16f524b8"
}

resource "cloudflare_dns_record" "mx_apex_primary" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = local.zone_name
  content  = local.mail_mx_primary
  priority = 10
  ttl      = 1
}

import {
  to = cloudflare_dns_record.mx_apex_secondary
  id = "${local.cloudflare_zone_id}/038a9666461a240b25b0ef29b5afdcbd"
}

resource "cloudflare_dns_record" "mx_apex_secondary" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = local.zone_name
  content  = local.mail_mx_secondary
  priority = 20
  ttl      = 1
}

import {
  to = cloudflare_dns_record.mx_wildcard_primary
  id = "${local.cloudflare_zone_id}/4c6e10c3e9e29d9a3d76788811d58361"
}

resource "cloudflare_dns_record" "mx_wildcard_primary" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = "*"
  content  = local.mail_mx_primary
  priority = 10
  ttl      = 1
}

import {
  to = cloudflare_dns_record.mx_wildcard_secondary
  id = "${local.cloudflare_zone_id}/6d4a3f2c31bb4ad8de27bba47daadef2"
}

resource "cloudflare_dns_record" "mx_wildcard_secondary" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = "*"
  content  = local.mail_mx_secondary
  priority = 20
  ttl      = 1
}

# --- TXT records ---

import {
  to = cloudflare_dns_record.spf
  id = "${local.cloudflare_zone_id}/c925852892c5c9d7b26d4bcb0476f912"
}

resource "cloudflare_dns_record" "spf" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = local.zone_name
  content = local.mail_spf
  ttl     = 1
}


# cf2024-1._domainkey TXT record is managed by Cloudflare Email Routing — not imported
