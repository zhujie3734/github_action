
provider "aws" {
    region = "eu-north-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "my-terraform-bucket"
}

terraform {
    backend "s3" {
      bucket = "my-terraform-bucket"
      key = "terraform/state.tfstate"
      region ="eu-north-1"
      encrypt = true
    }
    
}