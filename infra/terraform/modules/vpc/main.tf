resource "aws_vpc" "postgres_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "postgres-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.postgres_vpc.id
  tags   = { Name = "postgres-igw" }
}

# Public subnet - AZ-a - bastion
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.postgres_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-az-a" }
}

# Private subnet - AZ-a - primary
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "${var.aws_region}a"
  tags = { Name = "private-subnet-az-a-primary" }
}

# Private subnet - AZ-b - sync standby
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "${var.aws_region}b"
  tags = { Name = "private-subnet-az-b-sync-standby" }
}

# Private subnet - AZ-c - async standby
resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.postgres_vpc.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = "${var.aws_region}c"
  tags = { Name = "private-subnet-az-c-async-standby" }
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = { Name = "postgres-nat" }
}

# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.postgres_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table - shared by all 3 private subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.postgres_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "private-rt" }
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private3_assoc" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_rt.id
}