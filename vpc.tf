#conflict with subnets in vpc
resource "aws_vpc" "eks_vpc" {
cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "eks_subnet_1" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = "10.1.0.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch =true
}

resource "aws_subnet" "eks_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
}