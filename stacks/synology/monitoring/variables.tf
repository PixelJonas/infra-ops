variable "synology_skip_cert_check" {
  description = "Skip Synology DSM certificate validation."
  type        = bool
  default     = true
}

# --- Image versions ---

variable "vmagent_image_tag" {
  description = "vmagent image tag."
  type        = string
  # renovate: datasource=docker depName=victoriametrics/vmagent
  default = "v1.131.0"
}

variable "victoriametrics_image_tag" {
  description = "VictoriaMetrics image tag."
  type        = string
  # renovate: datasource=docker depName=quay.io/victoriametrics/victoria-metrics
  default = "v1.131.0"
}

variable "grafana_image_tag" {
  description = "Grafana image tag."
  type        = string
  # renovate: datasource=docker depName=grafana/grafana
  default = "9.2.7"
}

variable "unpoller_image_tag" {
  description = "Unpoller image tag."
  type        = string
  # renovate: datasource=docker depName=ghcr.io/unpoller/unpoller
  default = "v3.2.0"
}
