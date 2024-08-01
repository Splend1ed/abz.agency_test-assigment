locals {
  public_subnet_length   = length(var.public_subnets)
  private_subnets_length = length(var.private_subnets)
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  count = local.public_subnet_length

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = local.public_subnet_length

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}


resource "aws_subnet" "private" {
  count = local.private_subnets_length

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route_table_association" "private" {
  count = local.private_subnets_length

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_elasticache_subnet_group" "this" {
  name       = var.name
  subnet_ids = aws_subnet.private[*].id
}
