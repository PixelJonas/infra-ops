variable "synology_skip_cert_check" {
  description = "Skip Synology DSM certificate validation."
  type        = bool
  default     = true
}

variable "caddy_image_tag" {
  description = "Caddy base image tag used for the custom Cloudflare build."
  type        = string
  # renovate: datasource=docker depName=caddy
  default = "2.10.0"
}
