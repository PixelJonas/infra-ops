import {
  to = cloudflare_zone.janz_digital
  id = local.cloudflare_zone_id
}

resource "cloudflare_zone" "janz_digital" {
  account = {
    id = local.cloudflare_account_id
  }
  name = local.zone_name

  lifecycle {
    prevent_destroy = true
  }
}
