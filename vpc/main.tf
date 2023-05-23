provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Project = "Learn Networking"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "main" {
  vpc_id     = data.aws_vpc.default.id
  cidr_block = "172.31.48.0/20"

  tags = {
    Name = "Main"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = data.aws_vpc.default.id
  subnet_ids = [aws_subnet.main.id]
}

resource "aws_network_acl_rule" "allow_ssh" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 10
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number = 100
  egress = true
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 0
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

resource "aws_instance" "example" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = var.deployer_key
}

variable "deployer_key" {
  type = string
  default = "deployer"
}

output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
