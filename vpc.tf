
resource "aws_vpc" "eks_vpc" {
cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "eks_subnet" {
    vpc_id = aws_vpc.eks_vpc.vpc_id
    cidr_block = "10.1.0.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch =true
}

