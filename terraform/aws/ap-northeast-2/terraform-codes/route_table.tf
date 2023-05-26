resource "aws_route_table" "shlee-route-table-pub-sub1" {

  depends_on = [
    aws_vpc.shlee-vpc,
    aws_internet_gateway.shlee-internet-gateway
  ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shlee-internet-gateway.id
  }

  tags = {
    Name = "shlee-route-table-pub-sub1"
  }

  tags_all = {
    Name = "shlee-route-table-pub-sub1"
  }

  vpc_id = aws_vpc.shlee-vpc.id
}

resource "aws_route_table" "shlee-route-table-pub-sub3" {

  depends_on = [
    aws_vpc.shlee-vpc,
    aws_internet_gateway.shlee-internet-gateway
  ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shlee-internet-gateway.id
  }

  tags = {
    Name = "shlee-route-table-pub-sub3"
  }

  tags_all = {
    Name = "shlee-route-table-pub-sub3"
  }

  vpc_id = aws_vpc.shlee-vpc.id
}
