provider "aws" {
  region = "ap-northeast-1"
}

data "aws_ami" "amd_ubuntu" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server*"]
  }
}

data "aws_ami" "multiple_filters" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-*"]
  }

  filter {
    name = "architecture"
    values = ["arm64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "example" {
  ami = data.aws_ami.amd_ubuntu.id
  instance_type = "t4g.nano"

  tags = {
    Name = "tg4 example"
  }

  key_name = data.aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

data "aws_key_pair" "deployer" {
  key_name = "terraform-up-and-running"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh.id

  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

output "ami_id" {
  value = data.aws_ami.amd_ubuntu.id
}

output "ami_id_expected_equal" {
  value = data.aws_ami.multiple_filters.id
}

output "ami_name" {
  value = data.aws_ami.amd_ubuntu.name
}

output "instamce" {
  value = aws_instance.example.arn
}
