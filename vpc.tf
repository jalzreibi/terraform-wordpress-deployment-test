resource "aws_vpc" "Webapp-VPC" {
  tags = {
    Name = "Webapp-VPC"
  }
  tags_all = {
    Name = "Webapp-VPC"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_subnet" "db-euw-1b" {
  vpc_id     = aws_vpc.Webapp-VPC.id
  cidr_block = "10.0.11.0/24"
  tags = {
    "Name" = "db-euw-1b"
  }
  tags_all = {
    "Name" = "db-euw-1b"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_subnet" "webserver-euw-1b" {
  vpc_id     = aws_vpc.Webapp-VPC.id
  cidr_block = "10.0.1.0/24"
  tags = {
    "Name" = "webserver-euw-1b"
  }
  tags_all = {
    "Name" = "webserver-euw-1b"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_subnet" "bastion-euw-1b" {
  vpc_id                  = aws_vpc.Webapp-VPC.id
  cidr_block              = "10.0.253.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "bastion-euw-1b"
  }
  tags_all = {
    "Name" = "bastion-euw-1b"
  }
}
resource "aws_security_group" "db_sg" {
  description = "allow db inbound from webserver tier"
  tags = {
    "tier" = "database"
  }
  tags_all = {
    "tier" = "database"
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_security_group" "webserver_sg" {
  description = "Allow http and https from dmz, and allow db connection to db tier"
  tags = {
    "tier" = "webserver"
  }
  tags_all = {
    "tier" = "webserver"
  }
  lifecycle {
    prevent_destroy = true
  }
}
