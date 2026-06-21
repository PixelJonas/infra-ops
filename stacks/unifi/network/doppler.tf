data "doppler_secrets" "this" {}

locals {
  unifi_api_url = data.doppler_secrets.this.map.INFRA_UNIFI_API_URL
  unifi_api_key = data.doppler_secrets.this.map.INFRA_UNIFI_API_KEY
  unifi_site_id = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_SITE_ID)

  net_default_gw         = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_DEFAULT_GW)
  net_default_prefix     = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_DEFAULT_PREFIX)
  net_default_dhcp_start = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_DEFAULT_DHCP_START)
  net_default_dhcp_end   = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_DEFAULT_DHCP_END)
  net_default_domain     = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_DEFAULT_DOMAIN)

  net_prison_gw         = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_PRISON_GW)
  net_prison_prefix     = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_PRISON_PREFIX)
  net_prison_dhcp_start = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_PRISON_DHCP_START)
  net_prison_dhcp_end   = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_PRISON_DHCP_END)

  net_guest_gw         = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_GUEST_GW)
  net_guest_prefix     = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_GUEST_PREFIX)
  net_guest_dhcp_start = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_GUEST_DHCP_START)
  net_guest_dhcp_end   = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_NET_GUEST_DHCP_END)

  wifi_jarvis_pass    = data.doppler_secrets.this.map.INFRA_UNIFI_WIFI_JARVIS_PASS
  wifi_friday_pass    = data.doppler_secrets.this.map.INFRA_UNIFI_WIFI_FRIDAY_PASS
  wifi_bloomfeld_pass = data.doppler_secrets.this.map.INFRA_UNIFI_WIFI_BLOOMFELD_PASS

  dns_altus_apps_domain  = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DNS_ALTUS_APPS_DOMAIN)
  dns_altus_apps_ip      = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DNS_ALTUS_APPS_IP)
  dns_altus_api_domain   = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DNS_ALTUS_API_DOMAIN)
  dns_altus_api_ip       = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DNS_ALTUS_API_IP)
  dns_altus_apps2_domain = nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DNS_ALTUS_APPS2_DOMAIN)

  dhcp_reservations = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_DHCP_RESERVATIONS))
  fw_blocked_macs   = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_UNIFI_FW_BLOCKED_MACS))
}
