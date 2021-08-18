
 resource "aws_vpc" "vpc" {

  enable_dns_hostnames = true
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "public"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = "dev"
    Name        = "IG"
  }

}
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IG.id
  }
tags = {
    Environment = "dev"
    Name        = "RoutingTable"
  }

}

resource "aws_route_table_association" "subnet_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# resource "aws_route_table_association" "public_route_subnet" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_route.id
# }
