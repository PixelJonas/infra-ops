terraform {
  backend "s3" {
    key                         = "synology/nfs/terraform.tfstate"
    region                      = "us-west-002"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
