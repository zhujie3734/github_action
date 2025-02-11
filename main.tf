
provider "aws" {
    region = "eu-north-1"
}


terraform {
    backend "s3" {
      bucket = "my-terraform-bucket3734"
      key = "terraform/state.tfstate"
      region ="eu-north-1"
      encrypt = true
    }
    
}