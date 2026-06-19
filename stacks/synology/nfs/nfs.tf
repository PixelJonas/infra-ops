locals {
  media_nfs_clients = concat(local.nfs_cluster_cidrs, local.nfs_media_cidrs)

  nfs_security_sys = {
    sys                = true
    kerberos           = false
    kerberos_integrity = false
    kerberos_privacy   = false
  }

  nfs_shares = {
    media = {
      clients     = local.media_nfs_clients
      root_squash = "admin"
    }
    configs = {
      clients     = local.media_nfs_clients
      root_squash = "admin"
    }
    pmb-backup = {
      clients     = local.nfs_cluster_cidrs
      root_squash = "all_admin"
    }
    openshift = {
      clients     = local.nfs_openshift_clients
      root_squash = "all_admin"
    }
  }

  acl_enforce_script = <<-SCRIPT
    #!/bin/bash
    # Re-inherit Synology ACLs on media share subdirectories.
    # Prevents NFS write failures when a directory loses its ACLs.
    # Managed by Terraform (synology-nfs stack). Do not edit manually.
    /usr/syno/bin/synoacltool -enforce-inherit ${local.nfs_media_path}
  SCRIPT
}

resource "synology_core_task" "acl_enforce" {
  name     = "nfs-media-acl-enforce"
  user     = "root"
  enabled  = true
  schedule = "0 3 * * *"
  script   = local.acl_enforce_script
}

resource "synology_core_task" "acl_enforce_now" {
  name     = "nfs-media-acl-enforce-now"
  user     = "root"
  run      = true
  when     = "apply"
  schedule = "0 3 * * *"
  script   = local.acl_enforce_script
}

resource "synology_core_share_nfs_privilege" "this" {
  for_each   = local.nfs_shares
  share_name = each.key

  rules = [
    for client in each.value.clients : {
      client          = client
      privilege       = "rw"
      root_squash     = each.value.root_squash
      async           = true
      crossmnt        = true
      insecure        = true
      security_flavor = local.nfs_security_sys
    }
  ]
}
