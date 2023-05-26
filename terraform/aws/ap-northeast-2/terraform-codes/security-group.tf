
resource "aws_security_group" "shlee-sg-eks-cluster" {
  name        = "shlee-sg-eks-cluster"
  description = "security_group for shlee-eks-cluster"
  vpc_id      = aws_vpc.shlee-vpc.id

  tags = {
    Name = "shlee-sg-eks-cluster"
  }
}

resource "aws_security_group_rule" "shlee-sg-eks-cluster-ingress" {

  security_group_id = aws_security_group.shlee-sg-eks-cluster.id
  type              = "ingress"
  description       = "ingress security_group_rule for shlee-eks-cluster"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "shlee-sg-eks-cluster-egress" {

  security_group_id = aws_security_group.shlee-sg-eks-cluster.id
  type              = "egress"
  description       = "egress security_group_rule for shlee-eks-cluster"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}