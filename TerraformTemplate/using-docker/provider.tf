# Configure the AWS Provider
provider "aws" {
    version = "~> 2.0"
    region  = var.region
    shared_credentials_file = "/Users/ashishverma/.aws/creds"
}