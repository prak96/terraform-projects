
# Data Source to FETCH AMI ID for my Ubuntu server I am building
data "aws_ami" "ubuntu_eu" {

  most_recent = true
  owners      = ["099720109477"]
  # provider    = aws.eastus ### Explicitly calling "eu-west-1" REGIONAL PROVIDER 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


resource "aws_instance" "var_ubuntuVM" {
  ami      = data.aws_ami.ubuntu_eu.id
  # provider = aws.eastus

  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.var_frontSubnet.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.var_sg.id]

  tags = merge(local.tag_list, {
    "resource" = "AWS_Ubuntu_VM"
  })
}



