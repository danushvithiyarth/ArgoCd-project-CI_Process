resource "aws_route_table" "route-table-internetGW-public" {
  vpc_id = aws_vpc.A-CD-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.A-CD-internetGateway.id
  }

  tags = {
    Name = "route-table-internetGW-public"
  }
}

resource "aws_route_table" "route-table-NATGW-private" {
  vpc_id     = aws_vpc.A-CD-VPC.id
  depends_on = [aws_nat_gateway.NAT-Gateway_private-subnet]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-Gateway_private-subnet.id
  }

  tags = {
    Name = "route-table-NATGW-private"
  }
} 