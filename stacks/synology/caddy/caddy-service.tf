resource "synology_container_project" "caddy" {
  name       = "caddy"
  run        = true
  metadata   = {}
  share_path = local.caddy_share_path

  services = {
    caddy = {
      image          = local.caddy_custom_image
      container_name = "caddy"
      network_mode   = "host"
      restart        = "unless-stopped"
      environment = {
        CLOUDFLARE_API_TOKEN = local.cloudflare_api_token
      }
      volumes = [
        {
          type   = "bind"
          source = "${local.caddy_host_path}/Caddyfile"
          target = "/etc/caddy/Caddyfile"
        },
        {
          type   = "bind"
          source = "${local.caddy_host_path}/data"
          target = "/data"
          bind   = { create_host_path = true }
        },
        {
          type   = "bind"
          source = "${local.caddy_host_path}/config"
          target = "/config"
          bind   = { create_host_path = true }
        },
      ]
    }
  }

  depends_on = [
    synology_filestation_file.caddyfile,
    null_resource.caddy_build,
  ]
}
