resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NAT-Gateway_private-subnet" {
  depends_on    = [aws_eip.nat_ip]
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.A-CD-private-subnet-1c.id

  tags = {
    Name = "NAT-Gateway_private-subnet-1c"
  }
}