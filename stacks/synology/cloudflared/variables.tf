variable "synology_skip_cert_check" {
  description = "Skip Synology DSM certificate validation."
  type        = bool
  default     = true
}

variable "cloudflared_image_tag" {
  description = "cloudflared Docker image tag."
  type        = string
  # renovate: datasource=docker depName=cloudflare/cloudflared
  default = "2026.5.2"
}
