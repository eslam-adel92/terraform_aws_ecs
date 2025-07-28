data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = var.project_name
  }
}

resource "aws_eip" "eip_main" {
  domain = "vpc"
  tags = {
    Name = var.project_name
  }
}

resource "aws_nat_gateway" "natgw_main" {
  allocation_id = aws_eip.eip_main.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = var.project_name
  }
  depends_on = [aws_eip.eip_main]
}

resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_main.cidr_block, 3, count.index) # /19 subnets
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_main.cidr_block, 3, count.index + 3) # /19 subnets
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "${var.project_name}-private-${count.index}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.project_name}-public"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw_main.id
}

resource "aws_route_table_association" "public_rta" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.project_name}-private"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}