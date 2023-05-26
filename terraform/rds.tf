# Creating RDS Instance
resource "aws_db_subnet_group" "shlee-subnet_group" {
  name       = "shlee"
  subnet_ids = [aws_subnet.shlee-public-subnet1.id, aws_subnet.shlee-public-subnet3.id]

  tags = {
    Name = "Shlee DB subnet group"
  }
}

resource "aws_db_instance" "db-shlee" {
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.shlee-subnet_group.id
  engine                 = "mysql"
  engine_version         = "8.0.28"
  instance_class         = "db.t2.micro"
  multi_az               = false
  identifier             = "shlee"
  db_name                = "winwinmarket"
  username               = "shlee"
  password               = "비밀번호"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  publicly_accessible    = true
  availability_zone = "ap-northeast-2a"
}