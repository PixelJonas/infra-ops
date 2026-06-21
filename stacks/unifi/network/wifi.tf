resource "unifi_wifi_broadcast" "jarvis" {
  site_id                                 = local.unifi_site_id
  type                                    = "STANDARD"
  name                                    = "J.A.R.V.I.S"
  enabled                                 = true
  client_isolation_enabled                = false
  hide_name                               = false
  uapsd_enabled                           = false
  multicast_to_unicast_conversion_enabled = false
  broadcasting_frequencies_ghz            = [2.4, 5]
  band_steering_enabled                   = true
  arp_proxy_enabled                       = false
  bss_transition_enabled                  = true
  advertise_device_name                   = false

  network = {
    type = "NATIVE"
  }

  security_configuration = {
    type                 = "WPA2_PERSONAL"
    passphrase           = local.wifi_jarvis_pass
    fast_roaming_enabled = false
  }
}

resource "unifi_wifi_broadcast" "friday" {
  site_id                                 = local.unifi_site_id
  type                                    = "STANDARD"
  name                                    = "F.R.I.D.A.Y"
  enabled                                 = true
  client_isolation_enabled                = false
  hide_name                               = false
  uapsd_enabled                           = false
  multicast_to_unicast_conversion_enabled = false
  broadcasting_frequencies_ghz            = [2.4]
  arp_proxy_enabled                       = false
  bss_transition_enabled                  = true
  advertise_device_name                   = false

  network = {
    type = "NATIVE"
  }

  security_configuration = {
    type                 = "WPA2_PERSONAL"
    passphrase           = local.wifi_friday_pass
    fast_roaming_enabled = false
  }
}

resource "unifi_wifi_broadcast" "bloomfeld" {
  site_id                                 = local.unifi_site_id
  type                                    = "STANDARD"
  name                                    = "Bloomfeld"
  enabled                                 = true
  client_isolation_enabled                = false
  hide_name                               = false
  uapsd_enabled                           = false
  multicast_to_unicast_conversion_enabled = false
  broadcasting_frequencies_ghz            = [2.4, 5]
  band_steering_enabled                   = true
  arp_proxy_enabled                       = false
  bss_transition_enabled                  = true
  advertise_device_name                   = false

  network = {
    type       = "SPECIFIC"
    network_id = unifi_network.guest.id
  }

  security_configuration = {
    type                 = "WPA2_PERSONAL"
    passphrase           = local.wifi_bloomfeld_pass
    fast_roaming_enabled = false
  }
}
