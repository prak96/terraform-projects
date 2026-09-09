
locals {
  tag_list = {
    Iac = "Terraform"
    Project = "variables/Input"
  }
}

resource "aws_vpc" "var_myVPC" {
    cidr_block = "172.27.0.0/16"
    #provider   = aws.eastus
    tags = merge(local.tag_list,{
        "resource" = "aws-VPC"
    })
}

resource "aws_subnet" "var_frontSubnet" {
    vpc_id = aws_vpc.var_myVPC.id
    cidr_block = "172.27.2.0/24"
    #provider   = aws.eastus
    tags = merge(local.tag_list, {
        "resource" = "aws_frontsubnet"
    })
}

resource "aws_subnet" "var_backSubnet" {
    vpc_id = aws_vpc.var_myVPC.id
    cidr_block = "172.27.4.0/24"
    #provider   = aws.eastus
    tags = merge(local.tag_list, {
        "resource" = "aws_backsubnet"
    }) 
}

resource "aws_internet_gateway" "var_igw" {
    vpc_id = aws_vpc.var_myVPC.id
    #provider   = aws.eastus
    tags = merge(local.tag_list, {
        "resource" = "aws_internetgateway"
    })
}

resource "aws_security_group" "var_sg" {
    vpc_id = aws_vpc.var_myVPC.id
    #provider   = aws.eastus
    tags = merge(local.tag_list, {
        "resource" = "aws_sg"
    })
}

resource "aws_vpc_security_group_egress_rule" "var_sg_egress" {
    ip_protocol = "-1"
    #provider   = aws.eastus
    security_group_id = aws_security_group.var_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    tags = merge(local.tag_list, {
        "sgRule" = "Internet-Allow"
    })
}

resource "aws_vpc_security_group_ingress_rule" "var_sg_ingress_ssh" {
    ip_protocol = "tcp"
    #provider   = aws.eastus
    security_group_id = aws_security_group.var_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    description = "ssh_allow"
    tags = merge(local.tag_list, {
        "sgRule" = "ingress_ssh"
    })
}

resource "aws_vpc_security_group_ingress_rule" "var_sg_ingress_http" {
    ip_protocol = "tcp"
    #provider   = aws.eastus
    security_group_id = aws_security_group.var_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    description = "http_allow"
    tags = merge(local.tag_list, {
        "sgRule" = "ingress_http"
    })
}

resource "aws_vpc_security_group_ingress_rule" "var_sg_ingress_https" {
    ip_protocol = "tcp"
    #provider   = aws.eastus
    security_group_id = aws_security_group.var_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    description = "https_allow"
    tags = merge(local.tag_list, {
        "sgRule" = "ingress_https"
    })
}

resource "aws_vpc_security_group_ingress_rule" "var_sg_ingress_rdp" {
    ip_protocol = "tcp"
    #provider   = aws.eastus
    security_group_id = aws_security_group.var_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 3389
    to_port = 3389
    description = "https_allow"
    tags = merge(local.tag_list, {
        "sgRule" = "ingress_rdp"
    })
}


resource "aws_route_table" "var_sg_rtb" {
    vpc_id = aws_vpc.var_myVPC.id
    #provider   = aws.eastus
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.var_igw.id
    }
    tags = merge(local.tag_list, {
        "resource" = "aws_routetable"
    })
}

resource "aws_route_table_association" "var_sg_rtb_associate" {
    route_table_id = aws_route_table.var_sg_rtb.id
    subnet_id = aws_subnet.var_backSubnet.id
    #provider   = aws.eastus  
}
