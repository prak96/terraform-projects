data "aws_ami" "ubuntu_eu" {

  most_recent = true
  owners      = ["099720109477"]
  provider = aws.westeu             ## Explicitly calling "eu-west-1" REGIONAL PROVIDER 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


output "ubuntu_ami_data_eu" {
  value = data.aws_ami.ubuntu_eu.id
}



## Windows INSTANCE
resource "aws_instance" "Ubuntu-VM" {
  ami = data.aws_ami.ubuntu_eu.id         ## calling output of //data "aws_ami" "ubuntu_eu"//
  provider = aws.westeu
  
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.my_ds_subnet_public.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 60
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.my_ds_sg.id]

  ## Windows-VM USER LOGIN CREDENTIAL 
  user_data = <<-EOF
    <powershell>
    $username = "${var.windows_username}"
    $password = "${var.windows_password}"

    New-LocalUser `
        -Name $username `
        -Password $password `
        -FullName "WinServ-VM" `
        -Description "Created WINDOWS user within WinServ-VM" `
        -PasswordNeverExpires

    Add-LocalGroupMember `
      -Group "Administrators" `
      -Member $username

    Set-ItemProperty `
      -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" `
      -Name "fDenyTSConnections" `
      -Value 0

    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    </powershell>
EOF

  user_data_replace_on_change = true

  tags = merge(local.tags, {
    "resource" = "AWS_instance"
  })
}



