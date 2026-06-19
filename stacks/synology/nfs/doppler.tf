data "doppler_secrets" "this" {}

locals {
  synology_api_url              = data.doppler_secrets.this.map.INFRA_SYNOLOGY_API_URL
  synology_terraform_user       = data.doppler_secrets.this.map.SYNOLOGY_TERRAFORM_USERNAME
  synology_terraform_password   = data.doppler_secrets.this.map.SYNOLOGY_TERRAFORM_PASSWORD
  synology_terraform_otp_secret = data.doppler_secrets.this.map.SYNOLOGY_TERRAFORM_OTP_SECRET
  nfs_cluster_cidrs             = jsondecode(data.doppler_secrets.this.map.INFRA_NFS_CLUSTER_CIDRS)
  nfs_media_cidrs               = jsondecode(data.doppler_secrets.this.map.INFRA_NFS_MEDIA_CIDRS)
  nfs_openshift_clients         = jsondecode(data.doppler_secrets.this.map.INFRA_NFS_OPENSHIFT_CLIENTS)
  nfs_media_path                = data.doppler_secrets.this.map.INFRA_NFS_MEDIA_PATH
}
