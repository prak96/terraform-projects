
# Local Variable
variable "env" {
  type    = string
  default = "test"
}

variable "owner" {
  type    = string
  default = "prat"
}



# VPC & its components


## VPC
resource "aws_vpc" "prat_vpc" {
  cidr_block = "172.27.0.0/16"
  tags = {
    Name = "${var.env}-vpc" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env          ## Explicitly calling the INPUT of variable - "env"
  }
}

## Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.prat_vpc.id
  cidr_block = "172.27.1.0/24"
  tags = {
    Name = "${var.env}-publicSubnet" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env                   ## Explicitly calling the INPUT of variable - "env"
  }
}

## Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.prat_vpc.id
  cidr_block = "172.27.2.0/24"
  tags = {
    Name = "${var.env}-privateSubnet" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env                    ## Explicitly calling the INPUT of variable - "env"
  }
}


## Internet Gateway
resource "aws_internet_gateway" "prat_igw" {
  vpc_id = aws_vpc.prat_vpc.id
  tags = {
    Name = "${var.env}-igw" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env          ## Explicitly calling the INPUT of variable - "env"
  }
}


## Security Group
resource "aws_security_group" "prat_sg" {
  vpc_id = aws_vpc.prat_vpc.id
  tags = {
    Name = "${var.env}-sg" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env         ## Explicitly calling the INPUT of variable - "env"
  }
}

## Security Group Rules

### INBOUND Rules
resource "aws_vpc_security_group_ingress_rule" "http-allow" { ### HTTP Rule
  description       = "HTTP-allow"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.prat_sg.id
}

### INBOUND Rules
resource "aws_vpc_security_group_ingress_rule" "https-allow" { ### HTTPS Rule
  description       = "HTTPS-allow"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.prat_sg.id
}

### INBOUND Rules
resource "aws_vpc_security_group_ingress_rule" "ssh-allow" { ### HTTPS Rule
  description       = "SSH-allow"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.prat_sg.id
}

### OUTBOUND Rules
resource "aws_vpc_security_group_egress_rule" "internet" { ### INTERNET Rule
  description = "INTERNET-allow"
  ip_protocol = "-1"

  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.prat_sg.id
}


## Route TABLE & its ASSOCIATION

### Route TABLE
resource "aws_route_table" "prat_rtb" {
  vpc_id = aws_vpc.prat_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prat_igw.id
  }

  tags = {
    Name = "${var.env}-rtb" ## STRING CONCATENATION - Using SAME LOCAL Variable
    Env  = var.env          ## Explicitly calling the INPUT of variable - "env"
  }
}

### Route TABLE ASSOCIATION
resource "aws_route_table_association" "prat_rtb_associate" {
  route_table_id = aws_route_table.prat_rtb.id
  subnet_id      = aws_subnet.public-subnet.id
}

