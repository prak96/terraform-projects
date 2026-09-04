locals {
  tags = {
    provider = "terraform"
    project  = "amiFetchSetup"
  }
}

## VPC
resource "aws_vpc" "my_ds_vpc" {
  cidr_block = "192.168.0.0/16"
  provider = aws.westeu
  tags = merge(local.tags, {
    "resource" = "my_ds_VPC"
  })
}


## Public Subnet
resource "aws_subnet" "my_ds_subnet_public" {
  vpc_id     = aws_vpc.my_ds_vpc.id
  cidr_block = "192.168.2.0/24"
  provider = aws.westeu
  tags = merge(local.tags, {
    "resources" = "my_ds_SUBNET_public"
  })
}


## Private Subnet
resource "aws_subnet" "my_ds_subnet_private" {
  vpc_id     = aws_vpc.my_ds_vpc.id
  cidr_block = "192.168.1.0/24"
  provider = aws.westeu
  tags = merge(local.tags, {
    "resources" = "my_ds_SUBNET_private"
  })
}


## Internet Gateway
resource "aws_internet_gateway" "my_ds_igw" {
  vpc_id = aws_vpc.my_ds_vpc.id
  provider = aws.westeu
  tags = merge(local.tags, {
    "resource" = "my_ds_INTERNETGATEWAY"
  })
}


## Security Group
resource "aws_security_group" "my_ds_sg" {
  vpc_id = aws_vpc.my_ds_vpc.id
  provider = aws.westeu
  tags = merge(local.tags, {
    "resource" = "my_ds_SECURITYGROUP"
  })
}


## Security Group - INGRESS Rule
resource "aws_vpc_security_group_ingress_rule" "ingress_http" {
  provider = aws.westeu
  ip_protocol       = "tcp"

  security_group_id = aws_security_group.my_ds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  description       = "http-allow"
  tags = {
    "sgRule" = "ingress_http"
  }
}


## Security Group - INGRESS Rule
resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
  provider = aws.westeu
  ip_protocol       = "tcp"

  security_group_id = aws_security_group.my_ds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  description       = "https_allow"
  tags = merge(local.tags, {
    "sgRule" = "ingress_https"
  })
}


## Security Group - INGRESS Rule
resource "aws_vpc_security_group_ingress_rule" "ingress_ssh" {
  provider = aws.westeu
  ip_protocol       = "tcp"

  security_group_id = aws_security_group.my_ds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  description       = "ssh_allow"
  tags = merge(local.tags, {
    "sgRule" = "ingress_ssh"
  })
}


## Security Group - EGRESS Rule
resource "aws_vpc_security_group_egress_rule" "INTERNET-AllOW" {
  provider = aws.westeu
  ip_protocol       = "-1" ### can reach any kind of port in any kind of IP Addresses
  
  security_group_id = aws_security_group.my_ds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "INTERNET-ALLOW"
  tags = merge(local.tags, {
    "sgRule" = "Internet-Allow"
  })
}


## Route Table
resource "aws_route_table" "my_ds_rtb" {
  vpc_id = aws_vpc.my_ds_vpc.id
  provider = aws.westeu
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ds_igw.id
  }
  tags = merge(local.tags, {
    "resource" = "my_ds_ROUTETABLE"
  })
}


## Route Table Association
resource "aws_route_table_association" "my_ds_rtb" {
  provider = aws.westeu
  route_table_id = aws_route_table.my_ds_rtb.id
  subnet_id      = aws_subnet.my_ds_subnet_public.id
}

