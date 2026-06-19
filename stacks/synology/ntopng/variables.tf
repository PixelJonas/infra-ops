variable "synology_skip_cert_check" {
  description = "Skip Synology DSM certificate validation."
  type        = bool
  default     = true
}

variable "ntopng_image_tag" {
  description = "ntopng Docker image tag."
  type        = string
  # renovate: datasource=docker depName=ntop/ntopng
  default = "latest"
}
