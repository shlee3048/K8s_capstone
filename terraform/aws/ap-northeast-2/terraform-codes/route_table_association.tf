resource "aws_route_table_association" "shlee-route-association-pub-sub1" {
  route_table_id = aws_route_table.shlee-route-table-pub-sub1.id
  subnet_id      = aws_subnet.shlee-public-subnet1.id
}

resource "aws_route_table_association" "shlee-route-association-pub-sub3" {
  route_table_id = aws_route_table.shlee-route-table-pub-sub3.id
  subnet_id      = aws_subnet.shlee-public-subnet3.id
}