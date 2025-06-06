
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


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}
