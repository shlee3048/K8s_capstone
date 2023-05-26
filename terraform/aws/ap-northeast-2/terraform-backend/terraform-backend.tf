resource "aws_s3_bucket" "shlee-s3-tf-state" {

  bucket = "shlee-s3-tf-state"

  tags = {
    "Name" = "shlee-s3-tf-state"
  }
  
}

resource "aws_dynamodb_table" "shlee-ddb-tf-lock" {

  depends_on   = [aws_s3_bucket.shlee-s3-tf-state]
  name         = "shlee-ddb-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "Name" = "shlee-ddb-tf-lock"
  }

}