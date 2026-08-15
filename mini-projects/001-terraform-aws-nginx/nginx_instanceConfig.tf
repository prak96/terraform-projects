

##  VM Configuration
resource "aws_instance" "ngnix-vm" {
  # AMI ID NGINX  = ami-0dfee6e7eb44d480b
  # AMI ID Ubuntu = ami-0652a081025ec9fee
  # AMI ID Ubuntu (24.04) = ami-04df7d76c1b804451
  # AMI ID Ubuntu (Noble Numbat-24.04) = ami-077ab3d0a99f7e4e1
  ami                         = "ami-04df7d76c1b804451"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.my_subnet.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  #   lifecycle {
  #     create_before_destroy = true
  #   }

  ## SCRIPT --> to INSTALL & Configure NGNIX within server

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install nginx -y
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF

  user_data_replace_on_change = true ###Better Terraform solution: force replacement when user_data changes

  ## Attach Key Pair to access the instance via SSH
  # key_name = aws_key_pair.my_key.key_name

  tags = merge(local.tags, {
    Name = "VM"
  })

}


## Security Group
resource "aws_security_group" "my_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  description = "Security Group allowing traffic on specific ports"
  tags = merge(local.tags, {
    Name = "securityGroup"
  })
}

## Security Group EGRESS Rules
resource "aws_vpc_security_group_egress_rule" "internet" {
  ip_protocol       = "-1" ### can reach any kind of port in any kind of IP Addresses
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  description       = "internet-allow"
  tags = merge(local.tags, {
    Rule = "internet_allow"
  })
}



## Security Group INGRESS Rules
resource "aws_vpc_security_group_ingress_rule" "SSH" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  description       = "ssh_allow"
  tags = merge(local.tags, {
    Rule = "ssh_allow"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  description       = "http_allow"
  tags = merge(local.tags, {
    Rule = "http_allow"
  })
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  description       = "https_allow"
  tags = merge(local.tags, {
    Rule = "https_allow"
  })
}


# ## KEY PAIRS
# resource "aws_key_pair" "my_key" {
#   key_name   = "tf-nginx-key"
#   public_key = file("~/.ssh/ngnix_key_pair_repo/ngnix_key_pair.pub")
#   tags = merge(local.tags, {
#     Name = "keyPair"
#   })
# }
