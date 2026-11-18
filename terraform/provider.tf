
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "november-terraform-state-585768150796"
    key          = "november-cicd/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
