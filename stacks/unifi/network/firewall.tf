data "unifi_firewall_zone" "internal" {
  site_id = local.unifi_site_id
  name    = "Internal"
}

data "unifi_firewall_zone" "external" {
  site_id = local.unifi_site_id
  name    = "External"
}

resource "unifi_firewall_policy" "block_internet" {
  site_id             = local.unifi_site_id
  enabled             = true
  name                = "Block Internet"
  description         = "Blocks all access to the Internet"
  action              = "BLOCK"
  source_zone_id      = data.unifi_firewall_zone.internal.id
  destination_zone_id = data.unifi_firewall_zone.external.id
  ip_version          = "IPV4_AND_IPV6"
  logging_enabled     = false

  source_filter = {
    type          = "MAC_ADDRESS"
    mac_addresses = toset(local.fw_blocked_macs)
  }
}
