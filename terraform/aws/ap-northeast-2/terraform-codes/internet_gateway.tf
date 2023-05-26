resource "aws_internet_gateway" "shlee-internet-gateway" {

  depends_on = [
    aws_vpc.shlee-vpc
  ]

  vpc_id = aws_vpc.shlee-vpc.id
}