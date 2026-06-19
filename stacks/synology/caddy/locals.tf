locals {
  caddy_custom_image = "caddy-cloudflare:${var.caddy_image_tag}"

  caddyfile = templatefile("${path.module}/templates/Caddyfile.tftpl", {
    proxy_hosts = local.proxy_hosts
    acme_email  = local.acme_email
  })
}
