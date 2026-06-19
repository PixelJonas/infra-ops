variable "synology_skip_cert_check" {
  description = "Skip Synology DSM certificate validation."
  type        = bool
  default     = true
}

# --- Image versions ---

variable "tailsafe_version" {
  description = "TailSafe image tag."
  type        = string
  # renovate: datasource=docker depName=ghcr.io/pixeljonas/tailsafe-backrest
  default = "0.2.3"
}

variable "tailscale_docker_tag" {
  description = "Tailscale sidecar image tag."
  type        = string
  # renovate: datasource=docker depName=tailscale/tailscale
  default = "stable"
}
