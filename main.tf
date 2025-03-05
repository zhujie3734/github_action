
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

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}
