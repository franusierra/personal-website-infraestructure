terraform {
  backend "s3" {
    bucket = "franusi-terraform-states-prod"
    key    = "personal-website/terraform.tfstate"
    region = "eu-west-1"
  }
}
provider "aws" {
    profile    = "default"
    region     = "eu-west-1"
}
/* Provider for the cloudfront needed certificate */
provider "aws" {
    alias      = "us-east-1"
    profile    = "default"
    region     = "us-east-1"
}   
variable "personal_website_domain" {
    default = "franusi.com"
}
provider "github" {
  token = var.github_token
  owner = var.github_owner
}