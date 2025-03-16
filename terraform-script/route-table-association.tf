resource "aws_route_table_association" "route_table_acc_public-1a" {
  subnet_id      = aws_subnet.A-CD-public-subnet-1a.id
  route_table_id = aws_route_table.route-table-internetGW-public.id
}

resource "aws_route_table_association" "route_table_acc_public-1b" {
  subnet_id      = aws_subnet.A-CD-public-subnet-1b.id
  route_table_id = aws_route_table.route-table-internetGW-public.id
}

resource "aws_route_table_association" "route_table_acc_private-1c" {
  subnet_id      = aws_subnet.A-CD-private-subnet-1c.id
  route_table_id = aws_route_table.route-table-NATGW-private.id
}