import {
  to = unifi_network.default
  id = "${local.unifi_site_id}/56bfd66b-be6a-4576-ac3a-c75f61b358d3"
}

import {
  to = unifi_network.prison
  id = "${local.unifi_site_id}/6f96d845-c9ea-4783-b469-39adce8b0cda"
}

import {
  to = unifi_network.guest
  id = "${local.unifi_site_id}/b4d989c8-5f11-4154-8d65-235d85e3d5ae"
}

import {
  to = unifi_wifi_broadcast.jarvis
  id = "${local.unifi_site_id}/9224edc5-68db-41a5-af1c-87d154d3fabc"
}

import {
  to = unifi_wifi_broadcast.friday
  id = "${local.unifi_site_id}/1e29a6af-dd68-4e14-a4e2-602b690b5499"
}

import {
  to = unifi_wifi_broadcast.bloomfeld
  id = "${local.unifi_site_id}/c2745943-0a9e-4d4d-9487-3c95e0bb23b7"
}

import {
  to = unifi_firewall_policy.block_internet
  id = "${local.unifi_site_id}/53b9d467-b5a1-4872-b802-26e83b0a0255"
}

import {
  to = unifi_dns_policy.altus_apps
  id = "${local.unifi_site_id}/e99db30e-4a51-4626-a54e-1ff39dc779dc"
}

import {
  to = unifi_dns_policy.altus_api
  id = "${local.unifi_site_id}/9f456ea6-a584-4a6d-ab7f-75ee54b9a783"
}

import {
  to = unifi_dns_policy.altus_apps2
  id = "${local.unifi_site_id}/0de549f5-2633-477a-a241-a70964280357"
}

import {
  for_each = local.dhcp_reservations
  to       = unifi_dhcp_reservation.this[each.key]
  id       = "${local.unifi_site_id}/${each.value.mac}"
}
