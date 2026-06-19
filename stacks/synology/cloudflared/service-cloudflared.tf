resource "synology_container_project" "cloudflared" {
  name       = "cloudflared"
  run        = true
  metadata   = {}
  share_path = local.cloudflared_share_path

  services = {
    cloudflared = {
      image          = "cloudflare/cloudflared:${var.cloudflared_image_tag}"
      container_name = "cloudflared"
      restart        = "unless-stopped"
      network_mode   = "host"
      command = [
        "tunnel", "run",
        "--token", local.cloudflare_tunnel_token,
      ]
    }
  }
}
