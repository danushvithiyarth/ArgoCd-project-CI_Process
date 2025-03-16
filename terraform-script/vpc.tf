resource "aws_vpc" "A-CD-VPC" {
  cidr_block = var.cidr_block

  tags = {
    Name = "A-CD-VPC"
  }
}