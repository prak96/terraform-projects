
# Data Source to FETCH AMI ID for my WINDOWS server
data "aws_ami" "winserv_ami_id" {

  most_recent = true
  owners      = ["amazon"]
  provider    = aws.eastus ### Explicitly calling "us-east-1" REGIONAL PROVIDER 

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}



resource "aws_instance" "var_winVM" {
  ami = data.aws_ami.winserv_ami_id.id

  provider = aws.eastus

  associate_public_ip_address = true
  instance_type               = var.ec2_instance_type_var ## Fetching from "ec2_instance" variables
  subnet_id                   = aws_subnet.var_frontSubnet.id
  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume_size_var ## Fetching from "ec2_volume_size" variables
    volume_type           = var.ec2_volume_type_var ## Fetching from "ec2_type_size" variables
  }

  vpc_security_group_ids = [aws_security_group.var_sg.id]

  tags = merge(local.tag_list, {
    "resource" = "AWS_Ubuntu_VM"
  })
}



