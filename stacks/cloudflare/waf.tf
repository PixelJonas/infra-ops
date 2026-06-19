import {
  to = cloudflare_ruleset.custom_waf
  id = "zones/${local.cloudflare_zone_id}/964dc57893084997aad8903ede5b80e2"
}

resource "cloudflare_ruleset" "custom_waf" {
  zone_id = local.cloudflare_zone_id
  name    = "default"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      description = "Block non-Germany and high threat score"
      enabled     = true
      expression  = "(not ip.geoip.country in {\"DE\"} and not http.host in {\"tv.${local.zone_name}\"}) or (cf.threat_score gt 5)"
    },
  ]
}
