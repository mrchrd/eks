terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 2.52"

  region = local.aws_region
}
