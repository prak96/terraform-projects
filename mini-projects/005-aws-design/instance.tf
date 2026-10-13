
# AWS Instance


## Ubuntu Instance

data "aws_ami" "ubuntu_ami" {

  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "Ubuntu-VM" {
  ami = data.aws_ami.ubuntu_ami.id

  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 60
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.prat_sg.id]

  user_data_replace_on_change = true
  tags = {
    Name = "vpc"
    Env  = var.env
  }
}





















