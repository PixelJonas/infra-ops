provider "doppler" {}

provider "synology" {
  host            = local.synology_api_url
  user            = local.synology_user
  password        = local.synology_password
  skip_cert_check = var.synology_skip_cert_check
}
