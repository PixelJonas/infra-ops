resource "synology_container_project" "ntopng" {
  name       = "ntopng"
  run        = true
  metadata   = {}
  share_path = local.ntopng_share_path

  services = {
    ntopng = {
      image          = "ntop/ntopng:${var.ntopng_image_tag}"
      container_name = "ntopng"
      restart        = "unless-stopped"
      privileged     = true
      network_mode   = "host"
      user           = "0:0"
      environment = {
        TZ = local.timezone
      }
      command = flatten([
        "--http-port", local.ntopng_port,
        [for iface in local.ntopng_interfaces : ["-i", iface]],
        "--community",
      ])
      volumes = [
        {
          type   = "bind"
          source = local.ntopng_data_host_path
          target = "/var/lib/ntopng"
          bind   = { create_host_path = true }
        },
      ]
    }
  }
}
