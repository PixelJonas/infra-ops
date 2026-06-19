locals {
  firewall_script = <<-SCRIPT
    #!/bin/bash
    # Ensure iptables policies are ACCEPT so Docker can manage its own rules.
    # DSM may reset policies to DROP on boot even with the firewall disabled.
    # Managed by Terraform (synology-firewall stack). Do not edit manually.
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
  SCRIPT
}

resource "synology_core_task" "docker_firewall" {
  name     = "docker-firewall-accept"
  user     = "root"
  enabled  = true
  schedule = "0 0 * * *"
  script   = local.firewall_script
}

resource "synology_core_task" "docker_firewall_now" {
  name     = "docker-firewall-apply-now"
  user     = "root"
  run      = true
  when     = "apply"
  schedule = "0 0 * * *"
  script   = local.firewall_script
}
