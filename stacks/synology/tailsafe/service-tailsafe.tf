resource "synology_filestation_file" "tailsafe_site_config" {
  path           = "${local.tailsafe_backrest_share}/config/site.json"
  content        = local.site_config
  create_parents = true
  overwrite      = true
}

resource "synology_filestation_file" "tailsafe_serve" {
  for_each = local.tailsafe_serve_configs

  path           = "${local.tailsafe_backrest_share}/serve-config/${each.key}"
  content        = each.value
  create_parents = true
  overwrite      = true
}

resource "synology_container_project" "tailsafe" {
  name       = "tailsafe"
  run        = true
  metadata   = {}
  share_path = local.tailsafe_project_share_path

  services = merge(
    {
      configurator = {
        image          = "${local.tailsafe_image_namespace}/tailsafe-configurator:${var.tailsafe_version}"
        container_name = "tailsafe-configurator"
        restart        = "no"
        environment = {
          TAILSAFE_SITE_CONFIG                       = "/input/site.json"
          TAILSAFE_GENERATED_DIR                     = "/generated"
          RESTIC_REPOSITORY_PASSWORD                 = local.tailsafe_restic_repository_password
          TAILSAFE_INBOUND_BACKUP_HTTP_PASSWORD_FLORIAN = local.tailsafe_inbound_backup_password_florian
          TAILSAFE_INBOUND_MAINT_HTTP_PASSWORD_FLORIAN  = local.tailsafe_inbound_maint_password_florian
          TAILSAFE_REMOTE_BACKUP_HTTP_PASSWORD_FLORIAN  = local.tailsafe_remote_backup_password_florian
          TAILSAFE_REMOTE_MAINT_HTTP_PASSWORD_FLORIAN   = local.tailsafe_remote_maint_password_florian
        }
        volumes = [
          { type = "bind", source = local.tailsafe_generated_host, target = "/generated", bind = { create_host_path = true } },
          { type = "bind", source = "${local.tailsafe_backrest_host}/config/site.json", target = "/input/site.json", read_only = true },
        ]
      }

      tailscale-outbound = {
        image          = "tailscale/tailscale:${var.tailscale_docker_tag}"
        container_name = "tailsafe-tailscale-outbound"
        restart        = "unless-stopped"
        environment = {
          TS_AUTHKEY                    = local.tailsafe_outbound_authkey
          TS_HOSTNAME                   = local.tailsafe_outbound_hostname
          TS_STATE_DIR                  = "/var/lib/tailscale"
          TS_USERSPACE                  = "true"
          TS_AUTH_ONCE                  = "true"
          TS_EXTRA_ARGS                 = "--accept-dns=false"
          TS_OUTBOUND_HTTP_PROXY_LISTEN = ":1055"
          TS_SERVE_CONFIG               = local.tailsafe_serve_outbound_path
        }
        networks = {
          (local.tailsafe_outbound_network) = {}
        }
        volumes = [
          {
            type   = "bind"
            source = "${local.tailsafe_state_host}/outbound"
            target = "/var/lib/tailscale"
            bind   = { create_host_path = true }
          },
          {
            type      = "bind"
            source    = local.tailsafe_generated_host
            target    = "/generated"
            read_only = true
            bind      = { create_host_path = true }
          },
          {
            type      = "bind"
            source    = "${local.tailsafe_backrest_host}/serve-config"
            target    = "/serve-config"
            read_only = true
            bind      = { create_host_path = true }
          },
        ]
      }

      backrest = {
        image          = "${local.tailsafe_image_namespace}/tailsafe-backrest:${var.tailsafe_version}"
        container_name = "tailsafe-backrest"
        restart        = "unless-stopped"
        depends_on = {
          configurator       = { condition = "service_completed_successfully" }
          tailscale-outbound = { condition = "service_started" }
        }
        environment = {
          BACKREST_PORT              = "0.0.0.0:9898"
          BACKREST_CONFIG            = "/generated/backrest-config.json"
          BACKREST_DATA              = "/data"
          XDG_CACHE_HOME             = "/cache"
          TMPDIR                     = "/tmp"
          TZ                         = local.tailsafe_timezone
          RESTIC_REPOSITORY_PASSWORD = local.tailsafe_restic_repository_password
          HTTP_PROXY                 = "http://tailscale-outbound:1055"
          HTTPS_PROXY                = "http://tailscale-outbound:1055"
          http_proxy                 = "http://tailscale-outbound:1055"
          https_proxy                = "http://tailscale-outbound:1055"
          NO_PROXY                   = "127.0.0.1,localhost,hc-ping.com"
          no_proxy                   = "127.0.0.1,localhost,hc-ping.com"
        }
        networks = {
          (local.tailsafe_outbound_network) = {}
        }
        ports = [{
          host_ip   = "127.0.0.1"
          published = tostring(local.tailsafe_bind_port)
          target    = 9898
          protocol  = "tcp"
        }]
        volumes = local.tailsafe_backrest_volumes
      }
    },
    {
      (local.tailsafe_endpoint_service) = {
        image          = "tailscale/tailscale:${var.tailscale_docker_tag}"
        container_name = "tailsafe-${local.tailsafe_endpoint_service}"
        restart        = "unless-stopped"
        environment = {
          TS_AUTHKEY      = local.tailsafe_endpoint_authkey_florian
          TS_HOSTNAME     = local.tailsafe_endpoint_hostname_florian
          TS_STATE_DIR    = "/var/lib/tailscale"
          TS_USERSPACE    = "true"
          TS_AUTH_ONCE    = "true"
          TS_EXTRA_ARGS   = "--accept-dns=false"
          TS_SERVE_CONFIG = local.tailsafe_serve_endpoint_path
        }
        networks = {
          (local.tailsafe_endpoint_network) = {}
        }
        volumes = [
          {
            type   = "bind"
            source = local.tailsafe_endpoint_state_dir
            target = "/var/lib/tailscale"
            bind   = { create_host_path = true }
          },
          {
            type      = "bind"
            source    = local.tailsafe_generated_host
            target    = "/generated"
            read_only = true
            bind      = { create_host_path = true }
          },
          {
            type      = "bind"
            source    = "${local.tailsafe_backrest_host}/serve-config"
            target    = "/serve-config"
            read_only = true
            bind      = { create_host_path = true }
          },
        ]
      }

      "rest-server-backup-${local.tailsafe_peer_id}" = {
        image          = "${local.tailsafe_image_namespace}/tailsafe-rest-server:${var.tailsafe_version}"
        container_name = "tailsafe-rest-server-backup-${local.tailsafe_peer_id}"
        restart        = "unless-stopped"
        environment = {
          OPTIONS       = "--listen :8000 --append-only"
          PASSWORD_FILE = "/generated/rest-server-backup-${local.tailsafe_peer_id}.htpasswd"
        }
        networks = {
          (local.tailsafe_endpoint_network) = {}
        }
        volumes = [
          { type = "bind", source = local.tailsafe_generated_host, target = "/generated", read_only = true, bind = { create_host_path = true } },
          { type = "bind", source = local.tailsafe_peer_repo_host, target = "/data", bind = { create_host_path = true } },
        ]
      }

      "rest-server-maintenance-${local.tailsafe_peer_id}" = {
        image          = "${local.tailsafe_image_namespace}/tailsafe-rest-server:${var.tailsafe_version}"
        container_name = "tailsafe-rest-server-maintenance-${local.tailsafe_peer_id}"
        restart        = "unless-stopped"
        environment = {
          OPTIONS       = "--listen :8001"
          PASSWORD_FILE = "/generated/rest-server-maint-${local.tailsafe_peer_id}.htpasswd"
        }
        networks = {
          (local.tailsafe_endpoint_network) = {}
        }
        volumes = [
          { type = "bind", source = local.tailsafe_generated_host, target = "/generated", read_only = true, bind = { create_host_path = true } },
          { type = "bind", source = local.tailsafe_peer_repo_host, target = "/data", bind = { create_host_path = true } },
        ]
      }
    },
  )

  networks = {
    (local.tailsafe_outbound_network) = { driver = "bridge" }
    (local.tailsafe_endpoint_network) = { driver = "bridge" }
  }

  depends_on = [
    synology_filestation_file.tailsafe_site_config,
    synology_filestation_file.tailsafe_serve,
  ]

  lifecycle {
    precondition {
      condition     = local.tailsafe_peer_id != ""
      error_message = "INFRA_TAILSAFE_PEER_ID must be set in Doppler."
    }
  }
}
