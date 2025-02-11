
provider "aws" {
    region = "eu-north-1"
}

resource "aws_vpc" "vpc_a" {
cidr_block = "10.1.0.0/16"
}


terraform {
    backend "s3" {
      bucket = "my-terraform-bucket3734"
      key = "terraform/state.tfstate"
      region ="eu-north-1"
      encrypt = true
    }
    
}