locals {
  # --- Derived host paths ---
  tailsafe_generated_host     = "${local.tailsafe_backrest_host}/generated"
  tailsafe_endpoint_state_dir = "${local.tailsafe_state_host}/endpoint-${local.tailsafe_peer_id}"
  tailsafe_peer_repo_host     = "${local.tailsafe_repos_host}/${local.tailsafe_peer_repo_sub}"

  # --- Container network names ---
  tailsafe_outbound_network = "tailsafe-outbound"
  tailsafe_endpoint_network = "endpoint-net-${local.tailsafe_peer_id}"

  # --- Service names ---
  tailsafe_endpoint_service = "tailscale-endpoint-${local.tailsafe_peer_id}"
  tailsafe_bind_port        = 9898

  # --- Image namespace ---
  tailsafe_image_namespace = "ghcr.io/pixeljonas/tailsafe"

  # --- Render site.json from template ---
  site_config = templatefile("${path.module}/tailsafe/site.json.tftpl", {
    instance_name          = local.tailsafe_instance_name
    admin_user             = local.tailsafe_admin_user
    admin_password_bcrypt  = local.tailsafe_admin_password_bcrypt
    peer_id                = local.tailsafe_peer_id
    peer_repo_subdir       = local.tailsafe_peer_repo_sub
    peer_endpoint_hostname = local.tailsafe_peer_endpoint_hostname
    healthchecks           = local.tailsafe_healthchecks
    source_mounts          = local.tailsafe_source_mounts
  })

  # --- Serve config JSON blobs ---
  tailsafe_serve_configs = {
    "tailscale-serve-outbound.json" = jsonencode({
      TCP = { "9898" = { TCPForward = "backrest:9898" } }
    })
    "tailscale-serve-${local.tailsafe_peer_id}.json" = jsonencode({
      TCP = {
        "8000" = { TCPForward = "rest-server-backup-${local.tailsafe_peer_id}:8000" }
        "8001" = { TCPForward = "rest-server-maintenance-${local.tailsafe_peer_id}:8001" }
      }
    })
  }

  tailsafe_serve_outbound_path = "/serve-config/tailscale-serve-outbound.json"
  tailsafe_serve_endpoint_path = "/serve-config/tailscale-serve-${local.tailsafe_peer_id}.json"

  # --- Backrest volumes (core + source mounts) ---
  tailsafe_backrest_volumes = concat(
    [
      { type = "bind", source = local.tailsafe_generated_host, target = "/generated", bind = { create_host_path = true } },
      { type = "bind", source = "${local.tailsafe_backrest_host}/data", target = "/data", bind = { create_host_path = true } },
      { type = "bind", source = "${local.tailsafe_backrest_host}/cache", target = "/cache", bind = { create_host_path = true } },
      { type = "bind", source = "${local.tailsafe_backrest_host}/tmp", target = "/tmp", bind = { create_host_path = true } },
    ],
    [
      for mount in local.tailsafe_source_mounts : {
        type      = "bind"
        source    = mount.host
        target    = mount.container
        read_only = true
      }
    ],
  )
}
