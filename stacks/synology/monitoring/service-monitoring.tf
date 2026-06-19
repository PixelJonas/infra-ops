resource "synology_filestation_file" "scrape_config" {
  path      = "${local.monitoring_share_path}/vmagentdata/scrape.yaml"
  content   = local.scrape_config
  overwrite = true
}

resource "synology_container_project" "monitoring" {
  name       = "monitoring"
  run        = true
  metadata   = {}
  share_path = local.monitoring_share_path

  services = {
    victoriametrics = {
      image          = "quay.io/victoriametrics/victoria-metrics:${var.victoriametrics_image_tag}"
      container_name = "victoriametrics"
      restart        = "unless-stopped"
      network_mode   = "host"
      user           = "1500:1500"
      volumes = [
        {
          type   = "bind"
          source = "${local.monitoring_host_path}/victoria-metrics-data"
          target = "/victoria-metrics-data"
          bind   = { create_host_path = true }
        },
      ]
    }

    vmagent = {
      image          = "victoriametrics/vmagent:${var.vmagent_image_tag}"
      container_name = "vmagent"
      restart        = "always"
      depends_on = {
        victoriametrics = { condition = "service_started" }
      }
      command = [
        "--promscrape.config=/etc/prometheus/prometheus.yml",
        "--remoteWrite.url=${local.victoriametrics_write_url}",
      ]
      ports = [{
        published = "8429"
        target    = 8429
        protocol  = "tcp"
      }]
      volumes = [
        {
          type   = "bind"
          source = "${local.monitoring_host_path}/vmagentdata"
          target = "/vmagentdata"
          bind   = { create_host_path = true }
        },
        {
          type      = "bind"
          source    = "${local.monitoring_host_path}/vmagentdata/scrape.yaml"
          target    = "/etc/prometheus/prometheus.yml"
          read_only = true
        },
      ]
    }

    unpoller = {
      image          = "ghcr.io/unpoller/unpoller:${var.unpoller_image_tag}"
      container_name = "unpoller"
      restart        = "unless-stopped"
      ports = [{
        published = "9130"
        target    = 9130
        protocol  = "tcp"
      }]
      environment = {
        UP_INFLUXDB_DISABLE                  = "true"
        UP_POLLER_DEBUG                      = "false"
        UP_UNIFI_DYNAMIC                     = "false"
        UP_PROMETHEUS_HTTP_LISTEN            = "0.0.0.0:9130"
        UP_PROMETHEUS_NAMESPACE              = "unpoller"
        UP_UNIFI_CONTROLLER_0_PASS           = local.unpoller_unifi_pass
        UP_UNIFI_CONTROLLER_0_SAVE_ALARMS    = "true"
        UP_UNIFI_CONTROLLER_0_SAVE_ANOMALIES = "true"
        UP_UNIFI_CONTROLLER_0_SAVE_DPI       = "true"
        UP_UNIFI_CONTROLLER_0_SAVE_EVENTS    = "true"
        UP_UNIFI_CONTROLLER_0_SAVE_IDS       = "true"
        UP_UNIFI_CONTROLLER_0_SAVE_SITES     = "true"
        UP_UNIFI_CONTROLLER_0_URL            = local.unifi_host
        UP_UNIFI_CONTROLLER_0_USER           = local.unpoller_username
      }
    }

    grafana = {
      image          = "grafana/grafana:${var.grafana_image_tag}"
      container_name = "grafana"
      restart        = "always"
      depends_on = {
        victoriametrics = { condition = "service_started" }
      }
      ports = [{
        published = "3000"
        target    = 3000
        protocol  = "tcp"
      }]
      environment = {
        GF_INSTALL_PLUGINS = "grafana-clock-panel,natel-discrete-panel,grafana-piechart-panel"
      }
      volumes = [
        {
          type   = "bind"
          source = "${local.monitoring_host_path}/grafanadata"
          target = "/var/lib/grafana"
          bind   = { create_host_path = true }
        },
        {
          type   = "bind"
          source = "${local.monitoring_host_path}/provisioning"
          target = "/etc/grafana/provisioning"
          bind   = { create_host_path = true }
        },
      ]
    }
  }

  depends_on = [
    synology_filestation_file.scrape_config,
  ]

  lifecycle {
    ignore_changes = [services]
  }
}
