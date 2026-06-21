resource "unifi_dns_policy" "altus_apps" {
  site_id      = local.unifi_site_id
  type         = "A_RECORD"
  enabled      = true
  domain       = local.dns_altus_apps_domain
  ipv4_address = local.dns_altus_apps_ip
  ttl_seconds  = 0
}

resource "unifi_dns_policy" "altus_api" {
  site_id      = local.unifi_site_id
  type         = "A_RECORD"
  enabled      = true
  domain       = local.dns_altus_api_domain
  ipv4_address = local.dns_altus_api_ip
  ttl_seconds  = 0
}

resource "unifi_dns_policy" "altus_apps2" {
  site_id      = local.unifi_site_id
  type         = "A_RECORD"
  enabled      = true
  domain       = local.dns_altus_apps2_domain
  ipv4_address = local.dns_altus_api_ip
  ttl_seconds  = 0
}
