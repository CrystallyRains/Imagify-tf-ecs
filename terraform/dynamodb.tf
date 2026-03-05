resource "aws_dynamodb_table" "tf_lock" {
  name         = "imagify-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project     = "imagify"
    Environment = "dev"
    Terraform   = "true"
  }
}