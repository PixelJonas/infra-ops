provider "doppler" {}

provider "synology" {
  host            = local.synology_api_url
  user            = local.synology_terraform_user
  password        = local.synology_terraform_password
  otp_secret      = local.synology_terraform_otp_secret
  skip_cert_check = var.synology_skip_cert_check
}
