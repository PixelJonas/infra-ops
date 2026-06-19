resource "synology_filestation_folder" "caddy" {
  for_each = toset([
    local.caddy_share_path,
    "${local.caddy_share_path}/data",
    "${local.caddy_share_path}/config",
  ])

  path           = each.value
  create_parents = true
}

resource "synology_filestation_file" "caddyfile" {
  path      = "${local.caddy_share_path}/Caddyfile"
  content   = local.caddyfile
  overwrite = true

  depends_on = [synology_filestation_folder.caddy]
}
