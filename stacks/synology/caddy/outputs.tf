output "caddy_container_name" {
  description = "Name of the running Caddy container."
  value       = "caddy"
}

output "caddy_image" {
  description = "Custom Caddy Docker image with Cloudflare DNS module."
  value       = local.caddy_custom_image
}

output "proxy_hosts" {
  description = "Map of proxy host names to their domains."
  value       = { for k, v in local.proxy_hosts : k => v.domain }
}
