resource "unifi_dhcp_reservation" "this" {
  for_each = local.dhcp_reservations

  site_id     = local.unifi_site_id
  mac_address = each.value.mac
  fixed_ip    = each.value.ip
}
