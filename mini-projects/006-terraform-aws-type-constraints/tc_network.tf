
## VPC
resource "aws_vpc" "tc_vpc" {
    cidr_block = var.vpc_cidr
    tags = merge(local.universal_tags, {
        Name = local.vpc_name
    })
}


## Public Subnet
resource "aws_subnet" "tc_publicSubnet" {
    count = length()

    vpc_id = aws_vpc.tc_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)           ### Need CHATGPT

    tags = merge(local.universal_tags,{
        Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
        Type = "Public"
    })
}


## Internet Gateway
resource "aws_internet_gateway" "tc_igw" {
    vpc_id = aws_vpc.tc_vpc.id
    
    tags = merge(local.universal_tags,{
        Name = "${local.name_prefix}-igw"
    })
}

## Route Table
resource "aws_route_table" "tc_rtb" {
    vpc_id = aws_vpc.tc_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tc_igw.id
    }

    tags = merge(local.universal_tags,{
        Name = "${local.name_prefix}-rtb"
    })
}

## Route Table Association
resource "aws_route_table_association" "tc_rtb_associate" {
    route_table_id = aws_route_table.tc_rtb.id
    subnet_id = 
    
}

