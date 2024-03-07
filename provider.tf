terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  # profile    = "my-profile"
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}
