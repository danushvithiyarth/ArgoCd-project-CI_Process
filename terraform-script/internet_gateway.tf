resource "aws_internet_gateway" "A-CD-internetGateway" {
  vpc_id = aws_vpc.A-CD-VPC.id

  tags = {
    Name = "A-CD-internetGateway"
  }
}