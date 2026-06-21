resource "unifi_network" "default" {
  site_id                 = local.unifi_site_id
  name                    = "Default"
  management              = "GATEWAY"
  vlan_id                 = 1
  enabled                 = true
  isolation_enabled       = false
  cellular_backup_enabled = false
  internet_access_enabled = true
  mdns_forwarding_enabled = true
  zone_id                 = data.unifi_firewall_zone.internal.id

  ipv4_configuration = {
    auto_scale_enabled = true
    host_ip_address    = local.net_default_gw
    prefix_length      = tonumber(local.net_default_prefix)

    dhcp_configuration = {
      mode                            = "SERVER"
      start_ip_address                = local.net_default_dhcp_start
      end_ip_address                  = local.net_default_dhcp_end
      lease_time_seconds              = 86400
      domain_name                     = local.net_default_domain
      ping_conflict_detection_enabled = true
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "unifi_network" "prison" {
  site_id                 = local.unifi_site_id
  name                    = "PRISON"
  management              = "GATEWAY"
  vlan_id                 = 2
  enabled                 = true
  isolation_enabled       = false
  cellular_backup_enabled = true
  internet_access_enabled = true
  mdns_forwarding_enabled = true
  zone_id                 = data.unifi_firewall_zone.internal.id

  ipv4_configuration = {
    auto_scale_enabled = true
    host_ip_address    = local.net_prison_gw
    prefix_length      = tonumber(local.net_prison_prefix)

    dhcp_configuration = {
      mode                            = "SERVER"
      start_ip_address                = local.net_prison_dhcp_start
      end_ip_address                  = local.net_prison_dhcp_end
      lease_time_seconds              = 86400
      domain_name                     = ""
      ping_conflict_detection_enabled = true
    }
  }
}

resource "unifi_network" "guest" {
  site_id                 = local.unifi_site_id
  name                    = "GUEST"
  management              = "GATEWAY"
  vlan_id                 = 3
  enabled                 = true
  isolation_enabled       = false
  cellular_backup_enabled = true
  internet_access_enabled = true
  mdns_forwarding_enabled = true
  zone_id                 = data.unifi_firewall_zone.hotspot.id

  ipv4_configuration = {
    auto_scale_enabled = true
    host_ip_address    = local.net_guest_gw
    prefix_length      = tonumber(local.net_guest_prefix)

    dhcp_configuration = {
      mode                            = "SERVER"
      start_ip_address                = local.net_guest_dhcp_start
      end_ip_address                  = local.net_guest_dhcp_end
      lease_time_seconds              = 86400
      domain_name                     = ""
      ping_conflict_detection_enabled = true
    }
  }
}
