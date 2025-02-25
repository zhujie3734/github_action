#conflict with subnets in vpc
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

#Public subnets

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.eks_vpc.id
    cidr_block = "10.1.0.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch =true

    tags = {
    Name = "public-subnet-1"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
    "kubernetes.io/role/elb" = "1"
  }

}

#private subnet

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "private-subnet-1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "private-subnet-2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "eks-nat-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

