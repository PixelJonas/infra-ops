resource "null_resource" "caddy_build" {
  triggers = {
    image_tag = var.caddy_image_tag
  }

  provisioner "local-exec" {
    command = <<-CMD
      ssh ${local.synology_ssh_user}@${local.synology_ssh_host} \
        'sudo /volume1/@appstore/ContainerManager/usr/bin/docker build -t ${local.caddy_custom_image} -' <<'DOCKERFILE'
      FROM caddy:${var.caddy_image_tag}-builder AS builder
      RUN xcaddy build --with github.com/caddy-dns/cloudflare

      FROM caddy:${var.caddy_image_tag}
      COPY --from=builder /usr/bin/caddy /usr/bin/caddy
      DOCKERFILE
    CMD
  }
}
