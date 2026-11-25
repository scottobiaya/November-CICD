terraform {
  backend "s3" {
    bucket       = "november-terraform-state-585768150796"
    key          = "november-cicd/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
