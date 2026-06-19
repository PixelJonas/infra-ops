locals {
  scrape_config = templatefile("${path.module}/monitoring/scrape.yaml.tftpl", {
    hass_token     = local.hass_prometheus_token
    scrape_targets = local.scrape_targets
  })
}
