
## Global TAGS
locals {
  tags = {
    provider = "terraform"
    project  = "ngnixSetup"
  }
}



## VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.27.0.0/16"
  tags = merge(local.tags, {
    Name = "vpc"
  })
}


## Public Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.27.2.0/24"
  tags = merge(local.tags, {
    Name = "subnet"
  })
}


## Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = merge(local.tags, {
    Name = "internetGateway"
  })
}


## Route Table
resource "aws_route_table" "my_rtb" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = merge(local.tags, {
    Name = "routeTable"
  })
  # lifecycle {
  #   create_before_destroy = true

  # }
}

## Route Table Association
resource "aws_route_table_association" "my_rtb" {
  route_table_id = aws_route_table.my_rtb.id
  subnet_id      = aws_subnet.my_subnet.id
  lifecycle {
    create_before_destroy = true
  }
}

