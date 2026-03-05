resource "aws_s3_bucket" "tf_state" {
  bucket = "imagify-terraform-state"

  tags = {
    Project     = "imagify"
    Environment = "dev"
    Terraform   = "true"
  }
}