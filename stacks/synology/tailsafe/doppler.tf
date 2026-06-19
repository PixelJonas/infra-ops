data "doppler_secrets" "this" {}

locals {
  # --- Synology connection ---
  synology_api_url  = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_user     = data.doppler_secrets.this.map.SYNOLOGY_CSI_USERNAME
  synology_password = data.doppler_secrets.this.map.SYNOLOGY_PASSWORD

  # --- TailSafe paths (nonsensitive — used in resource attributes / for_each) ---
  tailsafe_project_share_path = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_PROJECT_SHARE_PATH)
  tailsafe_backrest_share     = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_BACKREST_SHARE_PATH)
  tailsafe_state_share        = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_STATE_SHARE_PATH)
  tailsafe_repos_share        = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_REPOS_SHARE_PATH)
  tailsafe_backrest_host      = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_BACKREST_HOST_PATH)
  tailsafe_state_host         = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_STATE_HOST_PATH)
  tailsafe_repos_host         = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_REPOS_HOST_PATH)
  tailsafe_config_host        = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_CONFIG_HOST_PATH)

  # --- TailSafe site config values (nonsensitive where used in resource attrs) ---
  tailsafe_instance_name          = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_INSTANCE_NAME)
  tailsafe_admin_user             = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_ADMIN_USER)
  tailsafe_admin_password_bcrypt  = data.doppler_secrets.this.map.INFRA_TAILSAFE_ADMIN_PASSWORD_BCRYPT
  tailsafe_peer_endpoint_hostname = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_PEER_ENDPOINT_HOSTNAME)
  tailsafe_healthchecks           = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_HEALTHCHECKS))
  tailsafe_source_mounts          = jsondecode(nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_SOURCE_MOUNTS))
  tailsafe_timezone               = nonsensitive(data.doppler_secrets.this.map.INFRA_TIMEZONE)

  # --- TailSafe peer config (nonsensitive — structural, used in resource keys) ---
  tailsafe_peer_id        = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_PEER_ID)
  tailsafe_peer_repo_sub  = nonsensitive(data.doppler_secrets.this.map.INFRA_TAILSAFE_PEER_REPO_SUBDIR)

  # --- TailSafe secrets (remain sensitive) ---
  tailsafe_restic_repository_password      = data.doppler_secrets.this.map.TAILSAFE_RESTIC_REPOSITORY_PASSWORD
  tailsafe_inbound_backup_password_florian = data.doppler_secrets.this.map.TAILSAFE_INBOUND_BACKUP_HTTP_PASSWORD_FLORIAN
  tailsafe_inbound_maint_password_florian  = data.doppler_secrets.this.map.TAILSAFE_INBOUND_MAINT_HTTP_PASSWORD_FLORIAN
  tailsafe_remote_backup_password_florian  = data.doppler_secrets.this.map.TAILSAFE_REMOTE_BACKUP_HTTP_PASSWORD_FLORIAN
  tailsafe_remote_maint_password_florian   = data.doppler_secrets.this.map.TAILSAFE_REMOTE_MAINT_HTTP_PASSWORD_FLORIAN
  tailsafe_outbound_authkey                = data.doppler_secrets.this.map.TAILSAFE_TS_OUTBOUND_AUTHKEY
  tailsafe_outbound_hostname               = data.doppler_secrets.this.map.TAILSAFE_TS_OUTBOUND_HOSTNAME
  tailsafe_endpoint_authkey_florian        = data.doppler_secrets.this.map.TAILSAFE_TS_ENDPOINT_AUTHKEY_FLORIAN
  tailsafe_endpoint_hostname_florian       = data.doppler_secrets.this.map.TAILSAFE_TS_ENDPOINT_HOSTNAME_FLORIAN
}
